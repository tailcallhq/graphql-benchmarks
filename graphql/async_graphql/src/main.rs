use std::time::Duration;

use async_graphql::{
    http::GraphiQLSource, Context, EmptyMutation, EmptySubscription, Object, Schema, SimpleObject,
};
use async_graphql_axum::GraphQL;
use axum::{
    response::{self, IntoResponse},
    routing::get,
    Router,
};

use reqwest::Proxy;
use tokio::net::TcpListener;

async fn graphiql() -> impl IntoResponse {
    response::Html(GraphiQLSource::build().endpoint("/").finish())
}

#[derive(SimpleObject, serde::Serialize, serde::Deserialize)]
pub struct User {
    id: u32,
    name: String,
    username: String,
    email: String,
    phone: String,
    website: String,
}

#[derive(Debug, SimpleObject, serde::Serialize, serde::Deserialize)]
pub struct Post {
    id: u32,
    #[serde(rename = "userId")]
    user_id: u32,
    title: String,
    body: String,
    // user: Option<User>,
}

pub struct QueryRoot;

const BASE_URL_POSTS: &str = "http://jsonplaceholder.typicode.com/posts";

#[Object]
impl QueryRoot {
    pub async fn posts(&self, ctx: &Context<'_>) -> anyhow::Result<Vec<Post>> {
        let client = ctx.data_unchecked::<reqwest::Client>();

        let c = client
            .get(BASE_URL_POSTS)
            .send()
            .await?
            .json::<Vec<Post>>()
            .await?;

        Ok(c)
    }
}

#[tokio::main]
async fn main() {
    let nginx_host = std::env::var("NGINX_HOST").unwrap_or("127.0.0.1".into());
    let nginx_port = std::env::var("NGINX_PORT").unwrap_or("3000".into());
    let nginx_url = format!("http://{}:{}", nginx_host, nginx_port);

    let client = reqwest::ClientBuilder::new()
        .proxy(Proxy::all(nginx_url).unwrap())
        .tcp_keepalive(Some(Duration::from_secs(60)))
        .tcp_nodelay(true)
        .no_gzip()
        .http2_keep_alive_timeout(Duration::from_secs(60))
        .pool_max_idle_per_host(200)
        .build()
        .unwrap();

    let schema = Schema::build(QueryRoot, EmptyMutation, EmptySubscription)
        .data(client)
        .finish();

    let app = Router::new().route("/graphql", get(graphiql).post_service(GraphQL::new(schema)));

    let listener = std::net::TcpListener::bind("0.0.0.0:8000").unwrap();
    listener.set_nonblocking(true).unwrap();

    println!("GraphiQL IDE: http://localhost:8000");

    axum::serve(TcpListener::from_std(listener).unwrap(), app)
        .await
        .unwrap();
}
