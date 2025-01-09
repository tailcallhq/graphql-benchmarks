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
|| [Tailcall] | `21,590.20` | `4.62` | `187.33x` |
|| [GraphQL JIT] | `1,105.95` | `89.88` | `9.60x` |
|| [async-graphql] | `1,016.43` | `97.84` | `8.82x` |
|| [Caliban] | `824.83` | `120.84` | `7.16x` |
|| [Gqlgen] | `369.86` | `266.32` | `3.21x` |
|| [Netflix DGS] | `193.72` | `500.38` | `1.68x` |
|| [Apollo GraphQL] | `134.38` | `687.04` | `1.17x` |
|| [Hasura] | `115.25` | `818.60` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,850.10` | `3.04` | `77.64x` |
|| [async-graphql] | `5,187.36` | `19.36` | `12.26x` |
|| [Caliban] | `4,914.32` | `20.75` | `11.62x` |
|| [GraphQL JIT] | `1,151.18` | `86.69` | `2.72x` |
|| [Gqlgen] | `1,117.17` | `97.94` | `2.64x` |
|| [Apollo GraphQL] | `898.20` | `111.77` | `2.12x` |
|| [Netflix DGS] | `827.58` | `122.08` | `1.96x` |
|| [Hasura] | `423.10` | `240.39` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,385.50` | `2.54` | `24.97x` |
|| [Caliban] | `34,231.60` | `2.93` | `21.70x` |
|| [Gqlgen] | `24,766.40` | `10.08` | `15.70x` |
|| [async-graphql] | `23,906.40` | `4.22` | `15.16x` |
|| [GraphQL JIT] | `4,603.39` | `21.67` | `2.92x` |
|| [Netflix DGS] | `4,264.39` | `28.00` | `2.70x` |
|| [Apollo GraphQL] | `3,934.43` | `27.64` | `2.49x` |
|| [Hasura] | `1,577.38` | `71.86` | `1.00x` |

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
