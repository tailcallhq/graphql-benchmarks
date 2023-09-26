# Benchmarking Setup Explanation
## Components

1. **nginx Reverse Proxy**:
    - It sits behind the GraphQL server.
    - All outbound requests from the GraphQL server are routed through nginx.
    - nginx is configured to cache the response for outbound requests.
    - Given that we're using `http://jsonplaceholder.typicode.com` as our data source, the proxy should be set up to forward requests to this endpoint while caching their responses to improve subsequent request times.
2. **GraphQL Server**:
    - Responses for any outbound request not cached.
    - Contains the schema with `Query`, `Post` types.
    - Resolves the `posts` field in the `Query` type by making a request to `http://jsonplaceholder.typicode.com/posts`.
3. **Benchmarking Tool (`wrk`)**:
    - Used to load test the GraphQL server.

**Flow**:

1. A client (in this case `wrk`) sends a request to the GraphQL server to fetch posts with title.
2. The GraphQL server receives the request and identifies that it needs to fetch data from the external source (`http://jsonplaceholder.typicode.com`).
3. The request is sent through the nginx proxy.
4. nginx checks if it has a cached response for the specific request.
   - If yes, it returns the cached response to the GraphQL server.
   - If no, it forwards the request to `http://jsonplaceholder.typicode.com`, caches the response (for subsequent requests), and then sends the response back to the GraphQL server.
5. The GraphQL server processes the data (combining post and user data, for example) and sends the final response back to the client (`wrk`).

## Graphql Schema
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
## wrk lua 
```lua showLineNumbers
  wrk.method = "POST"
  wrk.body = '{"operationName":null,"variables":{},"query":"{posts{title}}"}'
  wrk.headers["Connection"] = "keep-alive"
  wrk.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
  wrk.headers["Content-Type"] = "application/json"

```
