import com.github.plokhotnyuk.jsoniter_scala.core.JsonValueCodec
import com.github.plokhotnyuk.jsoniter_scala.macros.JsonCodecMaker
import sttp.client3.*
import sttp.client3.httpclient.zio.SttpClient
import sttp.client3.jsoniter.asJson
import zio.{RIO, RLayer, Task, ZIO, ZLayer}

trait Service {
  val posts: Task[List[Post]]
}

object Service {
  val posts: RIO[Service, List[Post]] = ZIO.serviceWithZIO(_.posts)

  val layer: RLayer[SttpClient, Service] = ZLayer.derive[Live]

  private class Live(client: SttpClient) extends Service {
    private val baseUrl = uri"http://jsonplaceholder.typicode.com"

    private def usersReq(id: Int) = basicRequest.get(baseUrl.withPath("users", id.toString)).response(asJson[User])

    val posts: Task[List[Post]] =
      client
        .send(basicRequest.get(baseUrl.withPath("posts")).response(asJson[List[PostDTO]]))
        .flatMap { resp =>
          ZIO.fromEither(resp.body.map(_.map { p =>
            Post(p.id, p.userId, p.title, p.body, ZIO.suspend(user(p.userId)))
          }))
        }

    def user(id: Int): Task[User] =
      client
        .send(usersReq(id))
        .map(_.body)
        .absolve

  }

  private case class PostDTO(
      id: Int,
      userId: Int,
      title: String,
      body: String
  )

  private given JsonValueCodec[User]          = JsonCodecMaker.make
  private given JsonValueCodec[List[PostDTO]] = JsonCodecMaker.make

}
