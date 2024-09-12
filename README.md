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
|| [Tailcall] | `18,013.30` | `5.54` | `147.29x` |
|| [GraphQL JIT] | `1,121.20` | `88.70` | `9.17x` |
|| [async-graphql] | `942.60` | `105.42` | `7.71x` |
|| [Caliban] | `749.32` | `133.19` | `6.13x` |
|| [Gqlgen] | `400.07` | `246.53` | `3.27x` |
|| [Netflix DGS] | `188.04` | `513.78` | `1.54x` |
|| [Apollo GraphQL] | `134.70` | `682.89` | `1.10x` |
|| [Hasura] | `122.30` | `762.59` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,932.70` | `3.23` | `65.67x` |
|| [async-graphql] | `5,025.90` | `19.95` | `10.67x` |
|| [Caliban] | `4,813.96` | `21.30` | `10.22x` |
|| [GraphQL JIT] | `1,166.52` | `85.55` | `2.48x` |
|| [Gqlgen] | `1,134.40` | `96.14` | `2.41x` |
|| [Apollo GraphQL] | `903.38` | `111.11` | `1.92x` |
|| [Netflix DGS] | `808.75` | `124.44` | `1.72x` |
|| [Hasura] | `471.05` | `216.73` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,777.40` | `2.64` | `25.35x` |
|| [Gqlgen] | `24,669.10` | `9.06` | `16.55x` |
|| [Tailcall] | `24,071.00` | `4.16` | `16.15x` |
|| [async-graphql] | `23,524.60` | `4.27` | `15.78x` |
|| [GraphQL JIT] | `4,576.85` | `21.79` | `3.07x` |
|| [Netflix DGS] | `4,118.47` | `29.50` | `2.76x` |
|| [Apollo GraphQL] | `3,998.31` | `28.50` | `2.68x` |
|| [Hasura] | `1,490.38` | `68.36` | `1.00x` |

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
