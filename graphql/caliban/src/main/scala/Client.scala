import com.github.plokhotnyuk.jsoniter_scala.core.*
import zio.*

import java.io.IOException
import java.net.*
import java.net.http.HttpResponse.BodyHandlers
import java.net.http.{HttpClient, HttpRequest, HttpResponse}

trait Client {
  def get[A](url: URI)(using JsonValueCodec[A]): Task[A]
}

object Client {

  private final class Live(client: HttpClient) extends Client {

    def get[A](uri: URI)(using JsonValueCodec[A]): Task[A] = {
      val req = HttpRequest.newBuilder(uri).version(HttpClient.Version.HTTP_1_1).build()
      ZIO
        .fromCompletableFuture(client.sendAsync(req, BodyHandlers.ofByteArray()))
        .map(r => readFromArray[A](r.body()))
    }
  }

  val live: TaskLayer[Client] = ZLayer.scoped {
    ZIO.executor.map { executor =>
        HttpClient
          .newBuilder()
          .followRedirects(HttpClient.Redirect.NEVER)
          .connectTimeout(30.seconds)
          .executor(executor.asJava)
          .proxy(proxy())
          .build()
      }.map(new Live(_))
  }

  private def proxy() = new ProxySelector {
    override def select(uri: URI): java.util.List[Proxy] = {
      val proxyList = new java.util.ArrayList[Proxy](1)
      val address   = InetSocketAddress.createUnresolved("127.0.0.1", 3000)
      val p         = new Proxy(Proxy.Type.HTTP, address)

      proxyList.add(p)
      proxyList
    }

    override def connectFailed(uri: URI, sa: SocketAddress, ioe: IOException): Unit = {
      throw new UnsupportedOperationException(
        s"Couldn't connect to the proxy server, uri: $uri, socket: $sa",
        ioe
      )
    }
  }
}
