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
|| [Tailcall] | `8,264.59` | `12.08` | `68.35x` |
|| [GraphQL JIT] | `1,113.03` | `89.36` | `9.20x` |
|| [async-graphql] | `988.74` | `100.43` | `8.18x` |
|| [Caliban] | `777.14` | `128.62` | `6.43x` |
|| [Gqlgen] | `397.24` | `248.30` | `3.29x` |
|| [Netflix DGS] | `182.89` | `530.63` | `1.51x` |
|| [Apollo GraphQL] | `130.25` | `702.60` | `1.08x` |
|| [Hasura] | `120.92` | `749.41` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,812.70` | `6.32` | `38.04x` |
|| [async-graphql] | `5,231.27` | `19.18` | `12.59x` |
|| [Caliban] | `4,762.07` | `21.52` | `11.46x` |
|| [GraphQL JIT] | `1,153.92` | `86.49` | `2.78x` |
|| [Gqlgen] | `1,133.12` | `96.74` | `2.73x` |
|| [Apollo GraphQL] | `895.81` | `112.01` | `2.16x` |
|| [Netflix DGS] | `795.75` | `126.05` | `1.91x` |
|| [Hasura] | `415.65` | `241.79` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,731.50` | `3.05` | `20.90x` |
|| [Gqlgen] | `24,608.40` | `8.26` | `15.71x` |
|| [async-graphql] | `23,902.90` | `4.20` | `15.26x` |
|| [Tailcall] | `20,573.20` | `4.88` | `13.13x` |
|| [GraphQL JIT] | `4,630.79` | `21.53` | `2.96x` |
|| [Apollo GraphQL] | `4,148.77` | `27.07` | `2.65x` |
|| [Netflix DGS] | `4,134.20` | `28.70` | `2.64x` |
|| [Hasura] | `1,566.45` | `63.60` | `1.00x` |

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
