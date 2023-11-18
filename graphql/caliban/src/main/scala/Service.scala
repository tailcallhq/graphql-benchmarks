import com.github.plokhotnyuk.jsoniter_scala.core.*
import com.github.plokhotnyuk.jsoniter_scala.macros.*
import zio.{RIO, RLayer, Task, ZIO, ZLayer}

import java.net.URI

trait Service {
  val posts: Task[List[Post]]
}

object Service {
  val posts: RIO[Service, List[Post]] = ZIO.serviceWithZIO(_.posts)

  val layer: RLayer[Client, Service] = ZLayer.derive[Live]

  private class Live(client: Client) extends Service {
    private inline val BaseUrl = "http://jsonplaceholder.typicode.com"

    val posts: Task[List[Post]] = {
      val uri = URI.create(BaseUrl + "/posts")
      client
        .get[List[PostDTO]](uri)
        .map(_.map { p => Post(p.id, p.userId, p.title, p.body, ZIO.suspend(user(p.userId))) })
    }

    def user(id: Int): Task[User] =
      client.get[User](URI.create(BaseUrl + "/users/" + id))

    private given JsonValueCodec[User]          = JsonCodecMaker.make
    private given JsonValueCodec[List[PostDTO]] = JsonCodecMaker.make
  }

  private case class PostDTO(
      id: Int,
      userId: Int,
      title: String,
      body: String
  )
}
