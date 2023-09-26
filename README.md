[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

- [Results](#results)
  - [Throughput (Higher is better)](#throughput-higher-is-better)
  - [Latency (Lower is better)](#latency-lower-is-better)
- [Architecture](#architecture)
  - [WRK](#wrk)
  - [GraphQL](#graphql)
  - [Nginx](#nginx)
  - [Jsonplaceholder](#jsonplaceholder)
- [GraphQL Schema](#graphql-schema)
- [Quick Start](#quick-start)
- [Contribute](#contribute)

This document presents a comparative analysis of several renowned GraphQL frameworks:

[Tailcall]: https://tailcall.run/
[Gqlgen]: https://gqlgen.com/
[Apollo GraphQL]: https://new.apollographql.com/
[Netflix DGS]: https://netflix.github.io/dgs/

## Results

<!-- PERFORMANCE_RESULTS_START -->

| Server           | Requests/sec | Latency (ms) |
| ---------------- | -----------: | -----------: |
| [Tailcall]       |   `2,890.68` |      `34.69` |
| [Gqlgen]         |     `935.00` |     `115.73` |
| [Apollo GraphQL] |     `793.37` |     `128.22` |
| [Netflix DGS]    |     `597.39` |     `191.85` |

<!-- PERFORMANCE_RESULTS_END -->

### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram.png)

### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram.png)

## Architecture

![Architecture Diagram](assets/architecture.png)

A client (in this case `wrk`) sends a request to the GraphQL server to fetch posts with title:

```graphql
{
  posts {
    title
  }
}
```

The GraphQL server receives the request and identifies that it needs to fetch data from the external source (`http://jsonplaceholder.typicode.com`). The request is sent to `jsonplaceholder` through a reverse proxy which is nginx in our case.

### WRK

We use wrk as our test client to send GraphQL requests at a very high rate.

### GraphQL

This is the actual GraphQL server that we are testing. We use various GraphQL implementations as mentioned above. While running the server we ensure that nothing is cached on the GraphQL server and it always has to make a request to the upstream service (nginx in this case) whenever a GraphQL request is received.

### Nginx

Acts as our reverse-proxy and sits behind the GraphQL server and caches every response. It is used to tackle rate-limiting and minimize network uncertainties produced while going over the internet to connect to jsonplaceholder.

### Jsonplaceholder

This acts as our core upstream service on which we are building a GraphQL API. We try to make a request to its `/posts` API multiple times via the GraphQL server.

## GraphQL Schema

This is the generated GraphQL schema.

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

## Quick Start

1. Click on this [link](https://codespaces.new/tailcallhq/graphql-benchmarks) to set up on GitHub Codespaces.
2. After completing the setup in Codespaces, you can start the benchmark tests by running:

```bash
./run_benchmarks.sh
```

## Contribute

We encourage you to try out these benchmarks for yourself and provide feedback. If you've worked with other GraphQL frameworks or have suggestions for tuning the existing ones for better performance, your contributions are most welcome. Open an issue or a pull request, and let's make this a comprehensive benchmarking setup for the GraphQL community!
