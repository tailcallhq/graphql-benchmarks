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
|| [Tailcall] | `27,894.20` | `3.57` | `116.40x` |
|| [async-graphql] | `1,925.61` | `52.56` | `8.04x` |
|| [Caliban] | `1,755.13` | `56.75` | `7.32x` |
|| [GraphQL JIT] | `1,260.61` | `79.00` | `5.26x` |
|| [Gqlgen] | `774.95` | `128.05` | `3.23x` |
|| [Netflix DGS] | `363.59` | `177.99` | `1.52x` |
|| [Apollo GraphQL] | `269.21` | `364.28` | `1.12x` |
|| [Hasura] | `239.63` | `411.81` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,871.20` | `1.72` | `78.98x` |
|| [Caliban] | `10,019.30` | `10.31` | `13.67x` |
|| [async-graphql] | `9,838.23` | `10.26` | `13.43x` |
|| [Gqlgen] | `2,181.29` | `47.51` | `2.98x` |
|| [Apollo GraphQL] | `1,743.58` | `57.29` | `2.38x` |
|| [Netflix DGS] | `1,587.87` | `71.10` | `2.17x` |
|| [GraphQL JIT] | `1,325.13` | `75.35` | `1.81x` |
|| [Hasura] | `732.74` | `137.01` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,294.20` | `1.11` | `26.65x` |
|| [Tailcall] | `58,715.80` | `1.71` | `23.25x` |
|| [Gqlgen] | `47,750.10` | `5.05` | `18.91x` |
|| [async-graphql] | `46,947.60` | `2.15` | `18.59x` |
|| [Netflix DGS] | `8,157.51` | `14.95` | `3.23x` |
|| [Apollo GraphQL] | `8,061.32` | `12.58` | `3.19x` |
|| [GraphQL JIT] | `5,041.54` | `19.80` | `2.00x` |
|| [Hasura] | `2,524.95` | `40.06` | `1.00x` |

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
