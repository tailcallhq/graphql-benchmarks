import caliban.interop.tapir.HttpInterpreter
import caliban.{RootResolver, ZHttpAdapter, graphQL}
import sttp.client3.SttpBackendOptions
import sttp.client3.httpclient.zio.HttpClientZioBackend
import sttp.tapir.json.jsoniter.*
import sttp.tapir.server.ziohttp.ZioHttpServerOptions
import zio.*
import zio.http.*

object Main extends ZIOAppDefault {
  private val clientOpts = SttpBackendOptions.Default.httpProxy("127.0.0.1", 3000)
  private val serverOpts = ZioHttpServerOptions.customiseInterceptors[Service].serverLog(None).options

  override val bootstrap: ZLayer[Any, Any, Any] = Runtime.removeDefaultLoggers

  private val api = graphQL(RootResolver(Query(Service.posts)))

  def run = {
    for
      interpreter <- api.interpreter
      httpService = ZHttpAdapter.makeHttpService(HttpInterpreter(interpreter))(using serverOpts)
      routes      = Http.collectHttp[Request] { case _ -> Root / "graphql" => httpService }
      _ <- Server.serve(routes)
    yield ()
  }.provide(
    Server.live,
    ZLayer.succeed(
      Server.Config.default
        .logWarningOnFatalError(false)
        .port(8084)
    ),
    Service.layer,
    HttpClientZioBackend.layer(clientOpts)
  )

}
