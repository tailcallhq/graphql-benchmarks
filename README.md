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
|| [Tailcall] | `21,350.60` | `4.67` | `178.34x` |
|| [GraphQL JIT] | `1,129.94` | `87.98` | `9.44x` |
|| [async-graphql] | `910.51` | `108.90` | `7.61x` |
|| [Caliban] | `801.91` | `124.54` | `6.70x` |
|| [Gqlgen] | `390.92` | `252.03` | `3.27x` |
|| [Netflix DGS] | `182.87` | `525.75` | `1.53x` |
|| [Apollo GraphQL] | `131.68` | `699.74` | `1.10x` |
|| [Hasura] | `119.72` | `618.93` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,609.80` | `2.97` | `73.20x` |
|| [async-graphql] | `4,955.72` | `20.22` | `10.79x` |
|| [Caliban] | `4,895.05` | `21.01` | `10.66x` |
|| [GraphQL JIT] | `1,153.53` | `86.53` | `2.51x` |
|| [Gqlgen] | `1,110.39` | `98.61` | `2.42x` |
|| [Apollo GraphQL] | `879.06` | `114.19` | `1.91x` |
|| [Netflix DGS] | `791.63` | `126.87` | `1.72x` |
|| [Hasura] | `459.14` | `223.22` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,220.60` | `2.49` | `25.37x` |
|| [Caliban] | `34,193.20` | `2.94` | `21.57x` |
|| [Gqlgen] | `23,931.60` | `8.87` | `15.10x` |
|| [async-graphql] | `22,776.60` | `4.40` | `14.37x` |
|| [GraphQL JIT] | `4,605.72` | `21.64` | `2.91x` |
|| [Netflix DGS] | `4,079.09` | `29.16` | `2.57x` |
|| [Apollo GraphQL] | `3,899.80` | `28.62` | `2.46x` |
|| [Hasura] | `1,585.34` | `64.33` | `1.00x` |

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
