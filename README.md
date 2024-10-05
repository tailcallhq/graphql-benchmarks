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
|| [Tailcall] | `13,665.90` | `7.28` | `120.04x` |
|| [GraphQL JIT] | `1,093.96` | `90.96` | `9.61x` |
|| [async-graphql] | `1,083.94` | `91.64` | `9.52x` |
|| [Caliban] | `910.13` | `109.74` | `7.99x` |
|| [Gqlgen] | `395.37` | `249.43` | `3.47x` |
|| [Netflix DGS] | `188.54` | `517.52` | `1.66x` |
|| [Apollo GraphQL] | `132.61` | `693.77` | `1.16x` |
|| [Hasura] | `113.84` | `813.67` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,583.00` | `4.61` | `48.21x` |
|| [Caliban] | `5,582.49` | `17.99` | `12.47x` |
|| [async-graphql] | `5,270.24` | `18.97` | `11.77x` |
|| [GraphQL JIT] | `1,137.06` | `87.75` | `2.54x` |
|| [Gqlgen] | `1,107.01` | `99.34` | `2.47x` |
|| [Apollo GraphQL] | `905.54` | `110.88` | `2.02x` |
|| [Netflix DGS] | `806.30` | `152.81` | `1.80x` |
|| [Hasura] | `447.65` | `226.49` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,057.20` | `2.02` | `29.45x` |
|| [Gqlgen] | `25,341.00` | `4.98` | `15.53x` |
|| [async-graphql] | `25,276.20` | `3.95` | `15.49x` |
|| [Tailcall] | `21,058.80` | `4.77` | `12.91x` |
|| [GraphQL JIT] | `4,464.48` | `22.35` | `2.74x` |
|| [Netflix DGS] | `4,115.08` | `28.32` | `2.52x` |
|| [Apollo GraphQL] | `4,057.24` | `28.46` | `2.49x` |
|| [Hasura] | `1,631.64` | `62.06` | `1.00x` |

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
