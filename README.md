Frameworks
- Tailcall (Rust)
- gqlgen (Go)
- Apollo graphql (NodeJS)
- Netflix DGS (Java)

Requirements
- Rust
- GoLang
- NodeJs
  install nvm
  nvm install v18.17.1
- Java
- wrk (sudo apt install wrk)
- Set ulimit

Build steps
Run build.sh in each dir
...

Benchmark setup
- GraphQL server runs on 8000
- Nginx on 8080, as proxy with caching enabled
- query to fetch a list of Posts {"query":"{ posts {title} }"} 
	- resolvers fetch posts from jsonplaceholder.typicode.com/posts 
- wrk - runs a load test to http://localhost:8000/graphql

To run
- execute run.sh in each dir to start the corresponding server
- execute wrk.sh in top level dir to run wrk

Results

|Name   | Language| Latency Avg | Requests Avg |
|-------|---------|-----------|----------|
| Tailcall | Rust | 27.16ms | 15kps |
| Netflix DGS | Java / Kotlin | 75.35ms | 6.5kps|
| gqlgen | Go | 73.60ms | 5.5kps |
| Apollo graphql | Node | 356.29ms | 1kps |

