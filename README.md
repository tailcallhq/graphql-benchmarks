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
|| [Tailcall] | `20,467.20` | `4.87` | `171.55x` |
|| [GraphQL JIT] | `1,145.38` | `86.76` | `9.60x` |
|| [async-graphql] | `964.38` | `102.95` | `8.08x` |
|| [Caliban] | `714.54` | `142.13` | `5.99x` |
|| [Gqlgen] | `391.89` | `251.32` | `3.28x` |
|| [Netflix DGS] | `183.25` | `526.79` | `1.54x` |
|| [Apollo GraphQL] | `132.22` | `696.84` | `1.11x` |
|| [Hasura] | `119.31` | `785.36` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,153.30` | `3.11` | `71.97x` |
|| [async-graphql] | `5,069.65` | `19.75` | `11.35x` |
|| [Caliban] | `4,767.51` | `21.52` | `10.67x` |
|| [GraphQL JIT] | `1,169.70` | `85.31` | `2.62x` |
|| [Gqlgen] | `1,127.73` | `96.66` | `2.52x` |
|| [Apollo GraphQL] | `900.54` | `111.44` | `2.02x` |
|| [Netflix DGS] | `798.93` | `125.81` | `1.79x` |
|| [Hasura] | `446.79` | `235.57` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,132.60` | `2.56` | `27.36x` |
|| [Caliban] | `32,806.60` | `3.07` | `22.94x` |
|| [Gqlgen] | `24,367.30` | `8.84` | `17.04x` |
|| [async-graphql] | `23,468.60` | `4.30` | `16.41x` |
|| [GraphQL JIT] | `4,623.86` | `21.58` | `3.23x` |
|| [Apollo GraphQL] | `4,097.63` | `26.73` | `2.87x` |
|| [Netflix DGS] | `4,095.63` | `28.43` | `2.86x` |
|| [Hasura] | `1,430.22` | `70.89` | `1.00x` |

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
