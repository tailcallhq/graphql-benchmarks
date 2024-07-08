use std::{collections::HashMap, sync::Arc, time::Duration};

use async_graphql::{
    dataloader::{DataLoader, Loader},
    http::GraphiQLSource,
    Context, EmptyMutation, EmptySubscription, Object, Schema, SimpleObject,
};
use async_graphql_axum::GraphQL;
use axum::{
    response::{self, IntoResponse},
    routing::get,
    Router,
};

use futures::future::try_join_all;
use reqwest::Proxy;
use tokio::net::TcpListener;

async fn graphiql() -> impl IntoResponse {
    response::Html(GraphiQLSource::build().endpoint("/").finish())
}

#[derive(SimpleObject, serde::Serialize, serde::Deserialize, Debug, Clone)]
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
    user: Option<User>,
}

pub struct QueryRoot;

const BASE_URL_POSTS: &str = "http://jsonplaceholder.typicode.com/posts";
const BASE_URL_USERS: &str = "http://jsonplaceholder.typicode.com/users";

pub struct UserLoader {
    client: reqwest::Client,
}

impl Loader<u32> for UserLoader {
    type Value = User;
    type Error = Arc<reqwest::Error>;

    async fn load(&self, keys: &[u32]) -> Result<HashMap<u32, Self::Value>, Self::Error> {
        let mut results = HashMap::new();
        for &key in keys {
            let user_url = format!("{}/{}", BASE_URL_USERS, key);
            let user = self
                .client
                .get(&user_url)
                .send()
                .await?
                .json::<User>()
                .await?;
            results.insert(key, user);
        }
        Ok(results)
    }
}

#[Object]
impl QueryRoot {
    pub async fn posts(&self, ctx: &Context<'_>) -> anyhow::Result<Vec<Post>> {
        let client = ctx.data_unchecked::<reqwest::Client>();
        let posts = client
            .get(BASE_URL_POSTS)
            .send()
            .await?
            .json::<Vec<Post>>()
            .await?;

        if !ctx.look_ahead().field("user").exists() {
            return Ok(posts);
        }

        let user_loader = Arc::new(DataLoader::new(
            UserLoader {
                client: client.clone(),
            },
            tokio::spawn,
        ));

        let mut post_user_futures = Vec::new();
        for post in posts {
            let user_loader = user_loader.clone();
            post_user_futures.push(async move {
                match user_loader.load_one(post.user_id).await {
                    Ok(Some(user)) => Ok(Post {
                        user: Some(user),
                        ..post
                    }),
                    Ok(None) => Ok(post),
                    Err(e) => Err(e),
                }
            });
        }

        let posts_with_users: Vec<Post> = try_join_all(post_user_futures).await?;

        Ok(posts_with_users)
    }
    pub async fn greet(&self) -> String {
        "Hello World!".to_string()
    }
}

fn main() {
    let cpus: usize = std::thread::available_parallelism().unwrap().into();
    let listener = std::net::TcpListener::bind("127.0.0.1:8000").unwrap();

    let mut threads = vec![];

    for _ in 0..cpus {
        let listener = listener.try_clone().unwrap();

        let handle = std::thread::spawn(move || {
            let _ = tokio::runtime::Builder::new_current_thread()
                .worker_threads(8)
                .enable_all()
                .build()
                .unwrap()
                .block_on(async move {
                    let client = reqwest::ClientBuilder::new()
                        .proxy(Proxy::all("http://127.0.0.1:3000").unwrap())
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

                    let app = Router::new()
                        .route("/graphql", get(graphiql).post_service(GraphQL::new(schema)));

                    println!("GraphiQL IDE: http://localhost:8000");
                    // For each thread
                    listener.set_nonblocking(true).unwrap();

                    axum::serve(TcpListener::from_std(listener).unwrap(), app)
                        .await
                        .unwrap();
                });
        });

        threads.push(handle);
    }

    for handle in threads {
        handle.join().unwrap();
    }
}
