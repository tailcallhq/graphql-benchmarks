# GraphQL Benchmarks <!-- omit from toc -->

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

Explore and compare the performance of the fastest GraphQL frameworks through our comprehensive benchmarks.

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [Benchmark Results](#benchmark-results)
  - [Throughput (Higher is better)](#throughput-higher-is-better)
  - [Latency (Lower is better)](#latency-lower-is-better)
- [Architecture](#architecture)
  - [WRK](#wrk)
  - [GraphQL](#graphql)
  - [Nginx](#nginx)
  - [Jsonplaceholder](#jsonplaceholder)
- [GraphQL Schema](#graphql-schema)
- [Contribute](#contribute)

[Tailcall]: https://github.com/tailcallhq/tailcall
[Gqlgen]: https://github.com/99designs/gqlgen
[Apollo GraphQL]: https://github.com/apollographql/apollo-server
[Netflix DGS]: https://github.com/netflix/dgs-framework
[Caliban]: https://github.com/ghostdogpr/caliban
[async-graphql]: https://github.com/async-graphql/async-graphql
[Hasura]: https://github.com/hasura/graphql-engine
[GraphQL JIT]: https://github.com/zalando-incubator/graphql-jit

## Introduction

This document presents a comparative analysis of several renowned GraphQL frameworks. Dive deep into the performance metrics, and get insights into their throughput and latency.

> **NOTE:** This is a work in progress suite of benchmarks, and we would appreciate help from the community to add more frameworks or tune the existing ones for better performance.

## Quick Start

Get started with the benchmarks:

1. Click on this [link](https://codespaces.new/tailcallhq/graphql-benchmarks) to set up on GitHub Codespaces.
2. Once set up in Codespaces, initiate the benchmark tests:

```bash
./setup.sh
./run_benchmarks.sh
```

## Benchmark Results

<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `29,567.50` | `3.37` | `122.69x` |
|| [async-graphql] | `2,036.37` | `49.07` | `8.45x` |
|| [Caliban] | `1,746.69` | `57.24` | `7.25x` |
|| [GraphQL JIT] | `1,310.97` | `75.95` | `5.44x` |
|| [Gqlgen] | `741.51` | `133.72` | `3.08x` |
|| [Netflix DGS] | `365.77` | `211.04` | `1.52x` |
|| [Apollo GraphQL] | `272.18` | `361.03` | `1.13x` |
|| [Hasura] | `240.99` | `409.02` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,359.90` | `1.70` | `80.72x` |
|| [async-graphql] | `10,275.50` | `9.75` | `14.21x` |
|| [Caliban] | `9,786.58` | `10.57` | `13.54x` |
|| [Gqlgen] | `2,112.97` | `49.06` | `2.92x` |
|| [Apollo GraphQL] | `1,783.17` | `56.01` | `2.47x` |
|| [Netflix DGS] | `1,616.02` | `69.26` | `2.24x` |
|| [GraphQL JIT] | `1,360.37` | `73.40` | `1.88x` |
|| [Hasura] | `722.99` | `140.57` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,296.60` | `1.04` | `27.66x` |
|| [Tailcall] | `58,605.70` | `1.72` | `23.73x` |
|| [async-graphql] | `47,922.60` | `2.17` | `19.41x` |
|| [Gqlgen] | `44,522.50` | `5.58` | `18.03x` |
|| [Netflix DGS] | `8,227.12` | `14.71` | `3.33x` |
|| [Apollo GraphQL] | `8,055.83` | `12.66` | `3.26x` |
|| [GraphQL JIT] | `5,031.25` | `19.84` | `2.04x` |
|| [Hasura] | `2,469.23` | `40.53` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->



### 1. `{posts {title body user {name}}}`
#### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram1.png)

#### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram1.png)

### 2. `{posts {title body}}`
#### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram2.png)

#### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram2.png)

### 3. `{greet}`
#### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram3.png)

#### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram3.png)

## Architecture

![Architecture Diagram](assets/architecture.png)

A client (`wrk`) sends requests to a GraphQL server to fetch post titles. The GraphQL server, in turn, retrieves data from an external source, `jsonplaceholder.typicode.com`, routed through the `nginx` reverse proxy.

### WRK

`wrk` serves as our test client, sending GraphQL requests at a high rate.

### GraphQL

Our tested GraphQL server. We evaluated various implementations, ensuring no caching on the GraphQL server side.

### Nginx

A reverse-proxy that caches every response, mitigating rate-limiting and reducing network uncertainties.

### Jsonplaceholder

The primary upstream service forming the base for our GraphQL API. We query its `/posts` API via the GraphQL server.

## GraphQL Schema

Inspect the generated GraphQL schema employed for the benchmarks:

```graphql
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
  user: User
}

type User {
  id: Int!
  name: String!
  username: String!
  email: String!
  phone: String
  website: String
}
```

## Contribute

Your insights are invaluable! Test these benchmarks, share feedback, or contribute by adding more GraphQL frameworks or refining existing ones. Open an issue or a pull request, and let's build a robust benchmarking resource together!
