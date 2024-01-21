import com.github.plokhotnyuk.jsoniter_scala.core.*
import com.github.plokhotnyuk.jsoniter_scala.macros.*
import zio.query.*
import zio.{RIO, RLayer, Task, ZIO, ZLayer}

import java.net.URI

trait Service {
  val posts: Task[List[Post]]
  def user(id: Int): TaskQuery[User]
}

object Service {
  val posts: RIO[Service, List[Post]]      = ZIO.serviceWithZIO(_.posts)
  def user(id: Int): RQuery[Service, User] = ZQuery.serviceWithQuery(_.user(id))

  val layer: RLayer[Client, Service] = ZLayer.derive[Live]

  private class Live(client: Client) extends Service {
    private inline val BaseUrl = "http://jsonplaceholder.typicode.com"

    val posts: Task[List[Post]] = {
      val uri = URI.create(BaseUrl + "/posts")
      client.get[List[Post]](uri)
    }

    def user(id: Int): TaskQuery[User] =
      UsersDataSource.get(id)

    private object UsersDataSource {
      def get(id: Int): TaskQuery[User] = ZQuery.fromRequest(Req(id))(usersDS)

      private case class Req(id: Int) extends Request[Throwable, User]

      private val usersDS = DataSource.fromFunctionZIO("UsersDataSource") { (req: Req) =>
        client.get[User](URI.create(BaseUrl + "/users/" + req.id))
      }

      private given JsonValueCodec[User] = JsonCodecMaker.make(CodecMakerConfig.withDecodingOnly(true))
    }

    private given JsonValueCodec[List[Post]] = JsonCodecMaker.make(CodecMakerConfig.withDecodingOnly(true))
  }
}
