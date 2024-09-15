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
|| [Tailcall] | `18,200.50` | `5.48` | `157.37x` |
|| [GraphQL JIT] | `1,149.47` | `86.52` | `9.94x` |
|| [async-graphql] | `1,024.55` | `96.89` | `8.86x` |
|| [Caliban] | `778.68` | `128.59` | `6.73x` |
|| [Gqlgen] | `392.89` | `251.03` | `3.40x` |
|| [Netflix DGS] | `182.91` | `527.13` | `1.58x` |
|| [Apollo GraphQL] | `129.39` | `704.34` | `1.12x` |
|| [Hasura] | `115.65` | `648.81` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,705.80` | `3.25` | `69.45x` |
|| [async-graphql] | `5,395.10` | `18.55` | `12.20x` |
|| [Caliban] | `4,811.55` | `21.17` | `10.88x` |
|| [GraphQL JIT] | `1,174.79` | `84.93` | `2.66x` |
|| [Gqlgen] | `1,137.27` | `96.53` | `2.57x` |
|| [Apollo GraphQL] | `882.07` | `113.80` | `2.00x` |
|| [Netflix DGS] | `778.72` | `129.39` | `1.76x` |
|| [Hasura] | `442.10` | `227.73` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,970.80` | `2.63` | `25.73x` |
|| [async-graphql] | `24,695.50` | `4.05` | `16.74x` |
|| [Gqlgen] | `24,257.40` | `9.99` | `16.44x` |
|| [Tailcall] | `24,175.30` | `4.15` | `16.38x` |
|| [GraphQL JIT] | `4,711.83` | `21.18` | `3.19x` |
|| [Netflix DGS] | `4,089.08` | `29.54` | `2.77x` |
|| [Apollo GraphQL] | `3,975.29` | `27.31` | `2.69x` |
|| [Hasura] | `1,475.67` | `71.07` | `1.00x` |

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
