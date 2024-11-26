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
|| [Tailcall] | `21,623.00` | `4.61` | `185.18x` |
|| [GraphQL JIT] | `1,141.93` | `86.94` | `9.78x` |
|| [async-graphql] | `956.85` | `103.79` | `8.19x` |
|| [Caliban] | `780.11` | `128.81` | `6.68x` |
|| [Gqlgen] | `392.88` | `250.95` | `3.36x` |
|| [Netflix DGS] | `188.64` | `510.34` | `1.62x` |
|| [Apollo GraphQL] | `128.14` | `714.87` | `1.10x` |
|| [Hasura] | `116.77` | `700.57` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,833.60` | `3.04` | `79.67x` |
|| [async-graphql] | `4,920.21` | `20.33` | `11.94x` |
|| [Caliban] | `4,824.16` | `21.22` | `11.71x` |
|| [GraphQL JIT] | `1,177.78` | `84.72` | `2.86x` |
|| [Gqlgen] | `1,106.50` | `99.22` | `2.68x` |
|| [Apollo GraphQL] | `878.12` | `114.33` | `2.13x` |
|| [Netflix DGS] | `800.72` | `125.32` | `1.94x` |
|| [Hasura] | `412.11` | `241.63` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,221.30` | `2.55` | `24.94x` |
|| [Caliban] | `33,565.70` | `3.00` | `21.34x` |
|| [Gqlgen] | `24,807.80` | `8.60` | `15.77x` |
|| [async-graphql] | `23,465.90` | `4.27` | `14.92x` |
|| [GraphQL JIT] | `4,785.57` | `20.83` | `3.04x` |
|| [Netflix DGS] | `4,218.48` | `28.62` | `2.68x` |
|| [Apollo GraphQL] | `3,925.94` | `28.38` | `2.50x` |
|| [Hasura] | `1,572.88` | `65.95` | `1.00x` |

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
