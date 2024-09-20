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
|| [Tailcall] | `20,027.30` | `4.92` | `181.04x` |
|| [GraphQL JIT] | `1,100.78` | `90.38` | `9.95x` |
|| [async-graphql] | `1,086.98` | `91.36` | `9.83x` |
|| [Caliban] | `833.99` | `119.63` | `7.54x` |
|| [Gqlgen] | `383.70` | `256.92` | `3.47x` |
|| [Netflix DGS] | `185.63` | `534.36` | `1.68x` |
|| [Apollo GraphQL] | `128.54` | `710.50` | `1.16x` |
|| [Hasura] | `110.62` | `692.31` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,567.90` | `3.02` | `78.71x` |
|| [Caliban] | `5,408.13` | `18.62` | `13.07x` |
|| [async-graphql] | `5,340.60` | `18.74` | `12.91x` |
|| [GraphQL JIT] | `1,146.60` | `86.98` | `2.77x` |
|| [Gqlgen] | `1,089.64` | `100.91` | `2.63x` |
|| [Apollo GraphQL] | `862.63` | `116.49` | `2.08x` |
|| [Netflix DGS] | `798.89` | `150.51` | `1.93x` |
|| [Hasura] | `413.75` | `241.54` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `45,220.50` | `2.14` | `31.60x` |
|| [async-graphql] | `25,830.40` | `3.86` | `18.05x` |
|| [Tailcall] | `25,320.10` | `3.93` | `17.69x` |
|| [Gqlgen] | `24,593.50` | `5.20` | `17.18x` |
|| [GraphQL JIT] | `4,660.56` | `21.42` | `3.26x` |
|| [Netflix DGS] | `4,109.95` | `29.09` | `2.87x` |
|| [Apollo GraphQL] | `3,935.85` | `29.62` | `2.75x` |
|| [Hasura] | `1,431.24` | `69.65` | `1.00x` |

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
