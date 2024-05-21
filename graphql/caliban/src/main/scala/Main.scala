import caliban.*
import caliban.execution.QueryExecution
import caliban.quick.*
import zio.*
import zio.http.netty.NettyConfig
import zio.http.netty.NettyConfig.LeakDetectionLevel
import zio.http.{Client as _, *}

object Main extends ZIOAppDefault {

  override val bootstrap =
    ZLayer.make[Any](
      Runtime.removeDefaultLoggers,
      Runtime.disableFlags(RuntimeFlag.FiberRoots),
      Runtime.enableLoomBasedExecutor,
      ZLayer.scoped(Configurator.setQueryExecution(QueryExecution.Batched))
    )

  private val api = graphQL(RootResolver(Query(Service.posts)))

  def run =
    api
      .toApp("/graphql")
      .flatMap(Server.serve[Service])
      .provide(
        Service.layer,
        Client.live,
        Server.customized,
        ZLayer.succeed(Server.Config.default.port(8000)),
        ZLayer.succeed(NettyConfig.default.leakDetection(LeakDetectionLevel.DISABLED))
      )
}
