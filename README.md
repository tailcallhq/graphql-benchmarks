### Frameworks compared
- Tailcall (Rust)
- gqlgen (Go)
- Apollo graphql (NodeJS)
- Netflix DGS (Java)

To run the benchmarks, you will need the following installed.
- Rust
- GoLang
- NodeJs
- Java 17
- wrk 

### Benchmarking setup
- Each GraphQL server runs on port `8000`, and is configured with the same schema, and a resolver to fetch the list of posts from `http://jsonplaceholder.typicode.com/posts`, through a proxy server at `http://localhost:8080`
- Nginx runs on port `8080`, with proxy forwarding and caching enabled
- The wrk.sh script in the wrk directory runs a load test with the following query to fetch a list of Posts 
```{"query":"{ posts {title} }"} ```

### Build

- Execute `build.sh` in each framework directory in the graphql dir.



## Running a benchmark
- execute `run.sh` in a framework dir to start the server.
- After the server has started, execute `wrk.sh` in the top level dir to run wrk


### Results 

|Name   | Language| Latency Avg | Requests Avg |
|-------|---------|-----------|----------|
| Tailcall | Rust | 27.16ms | 15kps |
| Netflix DGS | Java / Kotlin | 75.35ms | 6.5kps|
| gqlgen | Go | 73.60ms | 5.5kps |
| Apollo graphql | Node | 356.29ms | 1kps |

