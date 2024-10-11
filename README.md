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
|| [Tailcall] | `11,927.80` | `8.37` | `99.88x` |
|| [GraphQL JIT] | `1,130.03` | `87.96` | `9.46x` |
|| [async-graphql] | `1,009.37` | `98.20` | `8.45x` |
|| [Caliban] | `797.75` | `126.85` | `6.68x` |
|| [Gqlgen] | `394.09` | `250.13` | `3.30x` |
|| [Netflix DGS] | `188.52` | `513.17` | `1.58x` |
|| [Apollo GraphQL] | `133.56` | `692.74` | `1.12x` |
|| [Hasura] | `119.42` | `732.91` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `20,080.90` | `4.98` | `47.93x` |
|| [async-graphql] | `5,144.28` | `19.51` | `12.28x` |
|| [Caliban] | `4,876.61` | `21.07` | `11.64x` |
|| [GraphQL JIT] | `1,168.22` | `85.43` | `2.79x` |
|| [Gqlgen] | `1,122.31` | `97.72` | `2.68x` |
|| [Apollo GraphQL] | `878.65` | `114.04` | `2.10x` |
|| [Netflix DGS] | `808.78` | `124.51` | `1.93x` |
|| [Hasura] | `418.93` | `246.53` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,646.80` | `3.07` | `22.55x` |
|| [Gqlgen] | `23,840.80` | `9.62` | `16.46x` |
|| [async-graphql] | `23,413.70` | `4.31` | `16.17x` |
|| [Tailcall] | `19,608.20` | `5.12` | `13.54x` |
|| [GraphQL JIT] | `4,611.85` | `21.64` | `3.18x` |
|| [Netflix DGS] | `4,122.95` | `28.88` | `2.85x` |
|| [Apollo GraphQL] | `3,969.34` | `28.10` | `2.74x` |
|| [Hasura] | `1,448.02` | `70.45` | `1.00x` |

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
