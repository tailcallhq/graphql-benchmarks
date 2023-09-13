### Frameworks compared
- [Tailcall](https://github.com/tailcallhq/tailcall) (Rust)
- [gqlgen](https://github.com/99designs/gqlgen) (Go)
- [Apollo Server](https://www.apollographql.com/docs/apollo-server/) (NodeJS)
- [Netflix DGS](https://netflix.github.io/dgs/) (Java)

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

*(Note: to build tailcall, checkout the tailcall source in a different dir, and ensure that `build.sh` and `run.sh` refer to the source dir)*




## Running a benchmark
- execute `run.sh` in a framework dir to start the server.
- After the server has started, execute `wrk.sh` in the top level dir to run wrk


### Results 

|Name   | Language| Latency Avg (ms) | Requests/Sec  |
|-------|---------|-----------|----------:|
| Tailcall | Rust | `5.86` | `17,048` |
| Netflix DGS | Java / Kotlin | `18.37`  | `7,209`|
| gqlgen | Go | `18.59` | `5,510` |
| Apollo graphql (clustered) | Node | `24.74` | `4,054` |

