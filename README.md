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
|| [Tailcall] | `27,842.80` | `3.58` | `260.08x` |
|| [async-graphql] | `1,901.95` | `52.93` | `17.77x` |
|| [Caliban] | `1,787.72` | `55.70` | `16.70x` |
|| [GraphQL JIT] | `1,344.28` | `74.06` | `12.56x` |
|| [Gqlgen] | `795.62` | `124.71` | `7.43x` |
|| [Netflix DGS] | `358.96` | `178.21` | `3.35x` |
|| [Apollo GraphQL] | `271.57` | `361.90` | `2.54x` |
|| [Hasura] | `107.05` | `601.75` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `54,263.70` | `1.83` | `63.61x` |
|| [Caliban] | `9,793.82` | `10.56` | `11.48x` |
|| [async-graphql] | `9,610.86` | `10.47` | `11.27x` |
|| [Gqlgen] | `2,217.97` | `46.65` | `2.60x` |
|| [Apollo GraphQL] | `1,776.57` | `56.22` | `2.08x` |
|| [Netflix DGS] | `1,585.77` | `70.75` | `1.86x` |
|| [GraphQL JIT] | `1,394.57` | `71.60` | `1.63x` |
|| [Hasura] | `853.12` | `116.95` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,834.60` | `1.08` | `25.77x` |
|| [Tailcall] | `57,923.30` | `1.74` | `22.34x` |
|| [Gqlgen] | `47,542.60` | `5.15` | `18.33x` |
|| [async-graphql] | `46,348.50` | `2.19` | `17.87x` |
|| [Netflix DGS] | `8,152.75` | `15.06` | `3.14x` |
|| [Apollo GraphQL] | `8,118.63` | `12.41` | `3.13x` |
|| [GraphQL JIT] | `5,297.30` | `18.85` | `2.04x` |
|| [Hasura] | `2,593.34` | `38.50` | `1.00x` |

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
