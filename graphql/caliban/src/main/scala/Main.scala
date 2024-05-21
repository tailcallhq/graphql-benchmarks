import caliban.*
import caliban.execution.QueryExecution
import caliban.quick.*
import io.netty.channel.kqueue.KQueue
import io.netty.incubator.channel.uring.IOUring
import zio.*
import zio.http.netty.NettyConfig.LeakDetectionLevel
import zio.http.netty.{ChannelType, NettyConfig}
import zio.http.{Client as _, *}

object Main extends ZIOAppDefault {

  override val bootstrap =
    ZLayer.make[Any](
      Runtime.removeDefaultLoggers,
      Runtime.disableFlags(RuntimeFlag.FiberRoots),
      Runtime.enableLoomBasedExecutor,
      ZLayer.scoped(Configurator.setQueryExecution(QueryExecution.Batched))
    )

  private val nettyConfig: UIO[NettyConfig] = {
    if KQueue.isAvailable then ZIO.succeed(ChannelType.KQUEUE)
    else if IOUring.isAvailable then ZIO.succeed(ChannelType.URING)
    else ZIO.dieMessage("Expected KQueue or IOUring transport to be available")
  }.map(
    NettyConfig.default
      .maxThreads(java.lang.Runtime.getRuntime.availableProcessors())
      .leakDetection(LeakDetectionLevel.DISABLED)
      .channelType(_)
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
        ZLayer(nettyConfig)
      )
}
