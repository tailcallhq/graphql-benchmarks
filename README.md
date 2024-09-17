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
|| [Tailcall] | `17,644.70` | `5.65` | `149.58x` |
|| [GraphQL JIT] | `1,172.98` | `84.79` | `9.94x` |
|| [async-graphql] | `1,003.65` | `98.97` | `8.51x` |
|| [Caliban] | `732.55` | `136.98` | `6.21x` |
|| [Gqlgen] | `393.52` | `250.54` | `3.34x` |
|| [Netflix DGS] | `189.50` | `509.27` | `1.61x` |
|| [Apollo GraphQL] | `126.61` | `715.95` | `1.07x` |
|| [Hasura] | `117.96` | `788.43` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `29,612.00` | `3.38` | `64.28x` |
|| [async-graphql] | `5,041.10` | `19.86` | `10.94x` |
|| [Caliban] | `4,929.52` | `20.67` | `10.70x` |
|| [GraphQL JIT] | `1,216.90` | `82.01` | `2.64x` |
|| [Gqlgen] | `1,124.79` | `97.22` | `2.44x` |
|| [Apollo GraphQL] | `878.27` | `114.28` | `1.91x` |
|| [Netflix DGS] | `817.92` | `122.82` | `1.78x` |
|| [Hasura] | `460.67` | `225.14` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,443.30` | `2.60` | `25.74x` |
|| [Gqlgen] | `24,336.70` | `9.76` | `16.29x` |
|| [Tailcall] | `23,695.50` | `4.22` | `15.86x` |
|| [async-graphql] | `22,884.90` | `4.39` | `15.32x` |
|| [GraphQL JIT] | `4,778.28` | `20.88` | `3.20x` |
|| [Netflix DGS] | `4,268.62` | `27.91` | `2.86x` |
|| [Apollo GraphQL] | `3,989.46` | `27.64` | `2.67x` |
|| [Hasura] | `1,493.58` | `66.75` | `1.00x` |

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
