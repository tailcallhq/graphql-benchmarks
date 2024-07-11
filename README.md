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
|| [Tailcall] | `30,238.00` | `3.29` | `112.36x` |
|| [async-graphql] | `1,925.75` | `52.12` | `7.16x` |
|| [Caliban] | `1,554.19` | `64.44` | `5.78x` |
|| [Hasura] | `1,500.54` | `66.39` | `5.58x` |
|| [GraphQL JIT] | `1,406.56` | `70.80` | `5.23x` |
|| [Gqlgen] | `771.97` | `128.57` | `2.87x` |
|| [Netflix DGS] | `361.00` | `174.30` | `1.34x` |
|| [Apollo GraphQL] | `269.12` | `365.45` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,309.70` | `1.62` | `43.25x` |
|| [async-graphql] | `9,492.72` | `10.60` | `6.70x` |
|| [Caliban] | `9,428.52` | `10.95` | `6.65x` |
|| [Hasura] | `2,521.96` | `39.61` | `1.78x` |
|| [Gqlgen] | `2,161.43` | `47.90` | `1.52x` |
|| [Apollo GraphQL] | `1,782.71` | `56.04` | `1.26x` |
|| [Netflix DGS] | `1,575.59` | `70.50` | `1.11x` |
|| [GraphQL JIT] | `1,417.71` | `70.44` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,863.00` | `1.04` | `27.01x` |
|| [Tailcall] | `64,285.10` | `1.56` | `25.21x` |
|| [async-graphql] | `52,290.60` | `2.09` | `20.51x` |
|| [Gqlgen] | `48,361.90` | `5.00` | `18.97x` |
|| [Netflix DGS] | `8,138.22` | `15.04` | `3.19x` |
|| [Apollo GraphQL] | `8,114.08` | `12.48` | `3.18x` |
|| [GraphQL JIT] | `5,341.25` | `18.69` | `2.09x` |
|| [Hasura] | `2,549.63` | `39.12` | `1.00x` |

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
