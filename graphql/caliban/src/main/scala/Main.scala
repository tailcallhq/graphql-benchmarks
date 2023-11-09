import caliban.*
import com.github.plokhotnyuk.jsoniter_scala.core.*
import zio.*
import zio.http.Method.POST
import zio.http.{Client as _, *}

object Main extends ZIOAppDefault {

  override val bootstrap: ZLayer[Any, Any, Any] =
    Runtime.removeDefaultLoggers ++ Runtime.setExecutor(Executor.makeDefault(false))

  private val api = graphQL(RootResolver(Query(Service.posts)))

  def run = {
    for
      interpreter <- api.interpreter
      handleRequest = new RequestHandler(interpreter)
      routes        = Http.collectZIO { case req @ POST -> Root / "graphql" => handleRequest(req) }
      _ <- Server.serve(routes)
    yield ()
  }.provide(
    Server.live,
    ZLayer.succeed(Server.Config.default.port(8084).logWarningOnFatalError(false)),
    Service.layer,
    Client.live
  )

}

final class RequestHandler(interpreter: GraphQLInterpreter[Service, CalibanError]) {
  private val contentTypeJson: Headers = Headers(Header.ContentType(MediaType.application.json).untyped)

  def apply(request: Request): URIO[Service, Response] = {
    for {
      arr  <- request.body.asArray.orDie
      resp <- interpreter.executeRequest(readFromArray[GraphQLRequest](arr))
    } yield Response(Status.Ok, contentTypeJson, Body.fromChunk(Chunk.fromArray(writeToArray(resp))))
  }

}
