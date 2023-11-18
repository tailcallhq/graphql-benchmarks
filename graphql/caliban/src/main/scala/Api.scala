import caliban.*
import caliban.schema.Schema.*
import caliban.schema.{Schema, SchemaDerivation}
import zio.*

object ServiceSchema extends SchemaDerivation[Service]

case class Query(
    posts: RIO[Service, List[Post]]
) derives ServiceSchema.SemiAuto

case class User(
    id: Int,
    name: String,
    username: String,
    email: String,
    phone: Option[String],
    website: Option[String]
) derives ServiceSchema.SemiAuto

case class Post(
    id: Int,
    userId: Int,
    title: String,
    body: String,
    user: RIO[Service, User]
) derives ServiceSchema.SemiAuto
