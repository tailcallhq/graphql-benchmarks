import com.github.plokhotnyuk.jsoniter_scala.core.*
import org.apache.hc.client5.http.classic.methods.HttpGet
import org.apache.hc.client5.http.impl.classic.{CloseableHttpClient, HttpClients}
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager
import org.apache.hc.core5.http.io.HttpClientResponseHandler
import org.apache.hc.core5.http.{ClassicHttpResponse, HttpHost}
import zio.*

import java.net.*

trait Client {
  def get[A](url: URI)(using JsonValueCodec[A]): Task[A]
}

object Client {
  private final class Live(client: CloseableHttpClient) extends Client {

    private final class ResponseDecoder[A](using JsonValueCodec[A]) extends HttpClientResponseHandler[A] {
      override def handleResponse(response: ClassicHttpResponse): A = readFromStream(response.getEntity.getContent)
    }

    def get[A](uri: URI)(using JsonValueCodec[A]): Task[A] = {
      val req     = HttpGet(uri)
      val decoder = new ResponseDecoder[A]
      ZIO.attempt(client.execute(req, decoder))
    }
  }

  private val httpClient: TaskLayer[CloseableHttpClient] = ZLayer.scoped(
    ZIO.fromAutoCloseable(
      ZIO
        .succeed {
          HttpClients
            .custom()
            .setProxy(new HttpHost("http", "127.0.0.1", 3000))
            .setConnectionManager({
              val cm = new PoolingHttpClientConnectionManager()
              cm.setMaxTotal(2000)
              cm.setDefaultMaxPerRoute(200)
              cm
            })
            .build()
        }
    )
  )

  val live: TaskLayer[Client] = ZLayer.make[Client](httpClient, ZLayer.derive[Live])
}
