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
|| [Tailcall] | `20,997.80` | `4.75` | `187.95x` |
|| [GraphQL JIT] | `1,117.07` | `89.03` | `10.00x` |
|| [async-graphql] | `929.95` | `106.72` | `8.32x` |
|| [Caliban] | `765.63` | `130.33` | `6.85x` |
|| [Gqlgen] | `401.21` | `245.49` | `3.59x` |
|| [Netflix DGS] | `187.43` | `518.28` | `1.68x` |
|| [Apollo GraphQL] | `130.01` | `704.89` | `1.16x` |
|| [Hasura] | `111.72` | `817.61` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,328.80` | `3.00` | `73.75x` |
|| [async-graphql] | `4,984.02` | `20.06` | `11.03x` |
|| [Caliban] | `4,743.29` | `21.60` | `10.50x` |
|| [GraphQL JIT] | `1,135.94` | `87.84` | `2.51x` |
|| [Gqlgen] | `1,133.32` | `96.02` | `2.51x` |
|| [Apollo GraphQL] | `882.03` | `113.83` | `1.95x` |
|| [Netflix DGS] | `810.69` | `124.94` | `1.79x` |
|| [Hasura] | `451.90` | `233.59` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,101.40` | `2.49` | `26.12x` |
|| [Caliban] | `33,464.20` | `2.99` | `21.80x` |
|| [Gqlgen] | `24,016.60` | `9.29` | `15.64x` |
|| [async-graphql] | `23,333.90` | `4.29` | `15.20x` |
|| [GraphQL JIT] | `4,497.26` | `22.18` | `2.93x` |
|| [Netflix DGS] | `4,234.88` | `28.34` | `2.76x` |
|| [Apollo GraphQL] | `4,025.15` | `27.73` | `2.62x` |
|| [Hasura] | `1,535.20` | `67.94` | `1.00x` |

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
