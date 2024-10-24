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
|| [Tailcall] | `20,840.30` | `4.79` | `174.38x` |
|| [GraphQL JIT] | `1,155.80` | `86.01` | `9.67x` |
|| [async-graphql] | `985.83` | `100.71` | `8.25x` |
|| [Caliban] | `801.69` | `124.69` | `6.71x` |
|| [Gqlgen] | `392.32` | `251.31` | `3.28x` |
|| [Netflix DGS] | `185.67` | `521.48` | `1.55x` |
|| [Apollo GraphQL] | `134.28` | `686.54` | `1.12x` |
|| [Hasura] | `119.51` | `719.62` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,973.80` | `3.13` | `71.22x` |
|| [async-graphql] | `4,848.39` | `20.63` | `10.80x` |
|| [Caliban] | `4,842.67` | `21.20` | `10.79x` |
|| [GraphQL JIT] | `1,185.48` | `84.18` | `2.64x` |
|| [Gqlgen] | `1,116.99` | `98.15` | `2.49x` |
|| [Apollo GraphQL] | `915.31` | `109.55` | `2.04x` |
|| [Netflix DGS] | `804.93` | `124.73` | `1.79x` |
|| [Hasura] | `448.97` | `222.05` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,955.80` | `2.57` | `26.12x` |
|| [Caliban] | `33,531.10` | `2.99` | `22.49x` |
|| [Gqlgen] | `24,228.50` | `9.40` | `16.25x` |
|| [async-graphql] | `23,342.70` | `4.28` | `15.65x` |
|| [GraphQL JIT] | `4,790.53` | `20.83` | `3.21x` |
|| [Netflix DGS] | `4,191.78` | `28.29` | `2.81x` |
|| [Apollo GraphQL] | `4,133.28` | `27.51` | `2.77x` |
|| [Hasura] | `1,491.14` | `67.96` | `1.00x` |

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
