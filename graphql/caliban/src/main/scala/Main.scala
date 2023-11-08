import caliban.*
import caliban.interop.tapir.HttpInterpreter
import sttp.tapir.json.jsoniter.*
import sttp.tapir.server.ziohttp.ZioHttpServerOptions
import zio.*
import zio.http.{Client as _, *}

object Main extends ZIOAppDefault {
  override val bootstrap: ZLayer[Any, Any, Any] =
    Runtime.removeDefaultLoggers ++ Runtime.setExecutor(Executor.makeDefault(false))

  private val api = graphQL(RootResolver(Query(Service.posts)))

  def run = {
    for
      interpreter <- api.interpreter
      serverOpts  = ZioHttpServerOptions.customiseInterceptors[Service].serverLog(None).options
      httpService = ZHttpAdapter.makeHttpService(HttpInterpreter(interpreter))(using serverOpts)
      routes      = Http.collectHttp[Request] { case _ -> Root / "graphql" => httpService }
      _ <- Server.serve(routes)
    yield ()
  }.provide(
    Server.live,
    ZLayer.succeed(Server.Config.default.port(8084).logWarningOnFatalError(false)),
    Service.layer,
    Client.live
  )

}
