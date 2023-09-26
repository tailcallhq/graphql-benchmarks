# GraphQL Frameworks Benchmark

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

This document presents a comparative analysis of several renowned GraphQL frameworks:

- [**Tailcall**](https://tailcall.run/)
- [**Gqlgen**](https://gqlgen.com/)
- [**Apollo Server**](https://new.apollographql.com/)
- [**Netflix DGS**](https://netflix.github.io/dgs/)

## Benchmark Results
<!-- PERFORMANCE_RESULTS_START -->
| Server       | Requests/sec | Latency (ms) |
|--------------|--------------:|--------------:|
| Tailcall     | `2,890.68`   | `34.69`      |
| Gqlgen       | `935.00`     | `115.73`     |
| Apollo       | `793.37`     | `128.22`     |
| Netflix DGS  | `597.39`     | `191.85`     |

<!-- PERFORMANCE_RESULTS_END -->

### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram.png)

### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram.png)

## Quick Start

1. Click on this [link](https://codespaces.new/tailcallhq/graphql-benchmarks) to set up on GitHub Codespaces
2. After completing the setup in Codespaces, you can start the benchmark tests by running:
  ```bash
  ./run_benchmarks.sh
  ```


## Benchmarking Setup Explanation
### Architecture
![Architecture Diagram](assets/architecture.png)
### Components
1. **Benchmarking Tool (`wrk`)**:
   - Used to load test the GraphQL server.
2. **GraphQL Server**:
   - Responses for any outbound request not cached.
   - Contains the schema with `Query`, `Post` types.
   - Resolves the `posts` field in the `Query` type by making a request to `http://jsonplaceholder.typicode.com/posts`.
3. **Nginx Reverse Proxy**:
   - It sits behind the GraphQL server.
   - All outbound requests from the GraphQL server are routed through Nginx.
   - Nginx is configured to cache the response for outbound requests.
   - Given that we're using `http://jsonplaceholder.typicode.com` as our data source, the proxy should be set up to forward requests to this endpoint while caching their responses to improve subsequent request times.



### Flow

1. A client (in this case `wrk`) sends a request to the GraphQL server to fetch posts with title.
   - Benchmarking query: ```{posts{title}}```
2. The GraphQL server receives the request and identifies that it needs to fetch data from the external source (`http://jsonplaceholder.typicode.com`).
3. The request is sent through the Nginx proxy.
4. Nginx checks if it has a cached response for the specific request.
   - If yes, it returns the cached response to the GraphQL server.
   - If no, it forwards the request to `http://jsonplaceholder.typicode.com`, caches the response (for subsequent requests), and then sends the response back to the GraphQL server.
5. The GraphQL server processes the data (combining post and user data, for example) and sends the final response back to the client (`wrk`).
   - Graphql Schema
   ```graphql showLineNumbers
     schema {
       query: Query
     }
     
     type Query {
       posts: [Post]
     }
     
     type Post {
       id: Int!
       userId: Int!
       title: String!
       body: String!
     }
   ```