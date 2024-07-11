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
|| [Tailcall] | `30,754.30` | `3.24` | `111.36x` |
|| [async-graphql] | `1,899.73` | `53.13` | `6.88x` |
|| [Caliban] | `1,606.27` | `62.09` | `5.82x` |
|| [Hasura] | `1,517.09` | `65.82` | `5.49x` |
|| [GraphQL JIT] | `1,356.81` | `73.38` | `4.91x` |
|| [Gqlgen] | `787.89` | `125.92` | `2.85x` |
|| [Netflix DGS] | `359.34` | `224.15` | `1.30x` |
|| [Apollo GraphQL] | `276.17` | `355.97` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,608.80` | `1.59` | `44.54x` |
|| [async-graphql] | `9,492.66` | `10.64` | `6.75x` |
|| [Caliban] | `9,372.06` | `11.01` | `6.67x` |
|| [Hasura] | `2,534.98` | `39.42` | `1.80x` |
|| [Gqlgen] | `2,215.37` | `46.86` | `1.58x` |
|| [Apollo GraphQL] | `1,803.41` | `55.38` | `1.28x` |
|| [Netflix DGS] | `1,589.81` | `69.49` | `1.13x` |
|| [GraphQL JIT] | `1,405.78` | `71.04` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,942.10` | `1.11` | `26.52x` |
|| [Tailcall] | `64,810.00` | `1.55` | `25.30x` |
|| [async-graphql] | `50,854.30` | `2.01` | `19.85x` |
|| [Gqlgen] | `47,996.60` | `5.08` | `18.73x` |
|| [Netflix DGS] | `8,326.30` | `14.32` | `3.25x` |
|| [Apollo GraphQL] | `8,212.26` | `12.33` | `3.21x` |
|| [GraphQL JIT] | `5,287.80` | `18.88` | `2.06x` |
|| [Hasura] | `2,561.97` | `38.94` | `1.00x` |

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
