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
|| [Tailcall] | `26,981.90` | `3.69` | `286.18x` |
|| [async-graphql] | `1,994.75` | `50.48` | `21.16x` |
|| [Caliban] | `1,673.18` | `59.73` | `17.75x` |
|| [GraphQL JIT] | `1,312.93` | `75.85` | `13.93x` |
|| [Gqlgen] | `803.14` | `123.57` | `8.52x` |
|| [Netflix DGS] | `374.81` | `153.85` | `3.98x` |
|| [Apollo GraphQL] | `270.96` | `363.09` | `2.87x` |
|| [Hasura] | `94.28` | `550.19` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `55,837.90` | `1.79` | `61.91x` |
|| [async-graphql] | `9,971.92` | `10.09` | `11.06x` |
|| [Caliban] | `9,484.48` | `10.90` | `10.52x` |
|| [Gqlgen] | `2,220.61` | `46.59` | `2.46x` |
|| [Apollo GraphQL] | `1,776.57` | `56.22` | `1.97x` |
|| [Netflix DGS] | `1,622.28` | `69.79` | `1.80x` |
|| [GraphQL JIT] | `1,337.09` | `74.68` | `1.48x` |
|| [Hasura] | `901.91` | `110.66` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,077.50` | `1.17` | `23.46x` |
|| [Tailcall] | `58,084.70` | `1.74` | `20.62x` |
|| [async-graphql] | `48,759.60` | `2.10` | `17.31x` |
|| [Gqlgen] | `47,754.70` | `5.26` | `16.95x` |
|| [Netflix DGS] | `8,370.70` | `14.38` | `2.97x` |
|| [Apollo GraphQL] | `8,211.85` | `12.35` | `2.92x` |
|| [GraphQL JIT] | `5,173.62` | `19.30` | `1.84x` |
|| [Hasura] | `2,817.03` | `35.53` | `1.00x` |

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
