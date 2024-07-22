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

This document presents a comparative analysis of several renowned GraphQL solutions. Dive deep into the performance metrics, and get insights into their throughput and latency.

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
|| [async-graphql] | `10,412.00` | `147.99` | `17.58x` |
|| [Netflix DGS] | `9,907.41` | `175.64` | `16.72x` |
|| [GraphQL JIT] | `9,880.01` | `242.40` | `16.68x` |
|| [Gqlgen] | `1,448.80` | `79.74` | `2.45x` |
|| [Hasura] | `1,268.31` | `87.46` | `2.14x` |
|| [Apollo GraphQL] | `1,248.48` | `166.23` | `2.11x` |
|| [Caliban] | `757.51` | `257.01` | `1.28x` |
|| [Tailcall] | `592.42` | `227.60` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [async-graphql] | `23,335.10` | `24.29` | `18.33x` |
|| [Netflix DGS] | `20,600.60` | `44.12` | `16.18x` |
|| [GraphQL JIT] | `20,451.20` | `62.80` | `16.06x` |
|| [Gqlgen] | `7,036.34` | `23.19` | `5.53x` |
|| [Apollo GraphQL] | `6,829.44` | `27.47` | `5.36x` |
|| [Hasura] | `4,453.10` | `44.00` | `3.50x` |
|| [Caliban] | `1,462.79` | `78.87` | `1.15x` |
|| [Tailcall] | `1,273.29` | `86.31` | `1.00x` |
| 3 | `{ greet }` |
|| [Gqlgen] | `53,539.90` | `2.78` | `10.09x` |
|| [Apollo GraphQL] | `40,331.30` | `5.49` | `7.60x` |
|| [Hasura] | `39,528.60` | `8.54` | `7.45x` |
|| [async-graphql] | `38,009.10` | `5.71` | `7.16x` |
|| [Netflix DGS] | `25,211.90` | `9.83` | `4.75x` |
|| [GraphQL JIT] | `23,492.70` | `18.38` | `4.43x` |
|| [Caliban] | `18,230.80` | `20.44` | `3.43x` |
|| [Tailcall] | `5,307.93` | `24.38` | `1.00x` |

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
