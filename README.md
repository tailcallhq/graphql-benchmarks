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
|| [Tailcall] | `22,013.10` | `4.53` | `183.42x` |
|| [GraphQL JIT] | `1,155.73` | `86.01` | `9.63x` |
|| [async-graphql] | `968.98` | `102.45` | `8.07x` |
|| [Caliban] | `762.82` | `131.29` | `6.36x` |
|| [Gqlgen] | `399.53` | `246.42` | `3.33x` |
|| [Netflix DGS] | `188.41` | `517.05` | `1.57x` |
|| [Apollo GraphQL] | `129.92` | `706.57` | `1.08x` |
|| [Hasura] | `120.02` | `756.38` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,431.70` | `2.99` | `72.16x` |
|| [async-graphql] | `5,124.84` | `19.53` | `11.06x` |
|| [Caliban] | `4,783.52` | `21.44` | `10.33x` |
|| [GraphQL JIT] | `1,180.67` | `84.54` | `2.55x` |
|| [Gqlgen] | `1,139.29` | `96.00` | `2.46x` |
|| [Apollo GraphQL] | `886.13` | `113.35` | `1.91x` |
|| [Netflix DGS] | `808.30` | `124.55` | `1.74x` |
|| [Hasura] | `463.27` | `215.33` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,564.90` | `2.47` | `25.56x` |
|| [Caliban] | `33,150.30` | `3.02` | `20.89x` |
|| [Gqlgen] | `24,657.00` | `8.92` | `15.54x` |
|| [async-graphql] | `23,890.10` | `4.19` | `15.05x` |
|| [GraphQL JIT] | `4,692.55` | `21.27` | `2.96x` |
|| [Netflix DGS] | `4,165.19` | `28.84` | `2.62x` |
|| [Apollo GraphQL] | `3,958.07` | `27.84` | `2.49x` |
|| [Hasura] | `1,586.96` | `63.35` | `1.00x` |

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
