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
|| [Tailcall] | `21,444.00` | `4.65` | `183.30x` |
|| [GraphQL JIT] | `1,105.64` | `89.96` | `9.45x` |
|| [async-graphql] | `971.47` | `102.16` | `8.30x` |
|| [Caliban] | `815.25` | `122.33` | `6.97x` |
|| [Gqlgen] | `391.60` | `251.71` | `3.35x` |
|| [Netflix DGS] | `184.64` | `524.89` | `1.58x` |
|| [Apollo GraphQL] | `131.52` | `699.66` | `1.12x` |
|| [Hasura] | `116.99` | `770.84` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,774.00` | `3.05` | `73.63x` |
|| [async-graphql] | `5,056.48` | `19.82` | `11.36x` |
|| [Caliban] | `4,815.76` | `21.29` | `10.82x` |
|| [GraphQL JIT] | `1,134.06` | `87.99` | `2.55x` |
|| [Gqlgen] | `1,118.49` | `97.34` | `2.51x` |
|| [Apollo GraphQL] | `892.68` | `112.42` | `2.01x` |
|| [Netflix DGS] | `796.19` | `126.44` | `1.79x` |
|| [Hasura] | `445.14` | `237.40` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,632.50` | `2.53` | `27.52x` |
|| [Caliban] | `33,754.90` | `2.96` | `23.43x` |
|| [Gqlgen] | `24,454.40` | `10.84` | `16.98x` |
|| [async-graphql] | `23,220.60` | `4.32` | `16.12x` |
|| [GraphQL JIT] | `4,527.13` | `22.03` | `3.14x` |
|| [Netflix DGS] | `4,218.29` | `28.13` | `2.93x` |
|| [Apollo GraphQL] | `4,076.08` | `27.52` | `2.83x` |
|| [Hasura] | `1,440.38` | `69.39` | `1.00x` |

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
