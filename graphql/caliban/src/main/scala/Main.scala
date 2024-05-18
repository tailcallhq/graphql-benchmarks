import caliban.*
import caliban.execution.QueryExecution
import caliban.quick.*
import zio.*

object Main extends ZIOAppDefault {
  private val api = graphQL(RootResolver(Query(Service.posts)))
  override val bootstrap: ZLayer[ZIOAppArgs, Any, Any] = Runtime.removeDefaultLoggers

  def run =
    api
      .runServer(8000, apiPath = "/graphql")
      .provide(Service.layer, Client.live, ZLayer.scoped(Configurator.setQueryExecution(QueryExecution.Parallel)))
}
