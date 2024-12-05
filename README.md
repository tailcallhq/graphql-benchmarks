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
|| [Tailcall] | `21,473.80` | `4.65` | `177.69x` |
|| [GraphQL JIT] | `1,145.22` | `86.78` | `9.48x` |
|| [async-graphql] | `984.34` | `100.87` | `8.14x` |
|| [Caliban] | `799.33` | `125.27` | `6.61x` |
|| [Gqlgen] | `392.33` | `251.39` | `3.25x` |
|| [Netflix DGS] | `188.80` | `515.05` | `1.56x` |
|| [Apollo GraphQL] | `133.55` | `691.91` | `1.11x` |
|| [Hasura] | `120.85` | `757.91` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,993.50` | `3.03` | `70.55x` |
|| [async-graphql] | `5,096.27` | `19.65` | `10.90x` |
|| [Caliban] | `4,825.55` | `21.24` | `10.32x` |
|| [GraphQL JIT] | `1,174.89` | `84.93` | `2.51x` |
|| [Gqlgen] | `1,120.06` | `97.63` | `2.40x` |
|| [Apollo GraphQL] | `892.05` | `112.41` | `1.91x` |
|| [Netflix DGS] | `806.55` | `124.56` | `1.72x` |
|| [Hasura] | `467.66` | `239.71` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,609.20` | `2.53` | `25.06x` |
|| [Caliban] | `33,577.90` | `3.00` | `21.24x` |
|| [Gqlgen] | `23,977.40` | `10.12` | `15.17x` |
|| [async-graphql] | `23,349.50` | `4.32` | `14.77x` |
|| [GraphQL JIT] | `4,700.82` | `21.23` | `2.97x` |
|| [Netflix DGS] | `4,209.22` | `28.54` | `2.66x` |
|| [Apollo GraphQL] | `3,921.68` | `28.22` | `2.48x` |
|| [Hasura] | `1,580.56` | `66.58` | `1.00x` |

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
