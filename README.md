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
|| [Tailcall] | `21,537.70` | `4.64` | `195.88x` |
|| [GraphQL JIT] | `1,101.64` | `90.22` | `10.02x` |
|| [async-graphql] | `963.75` | `103.19` | `8.77x` |
|| [Caliban] | `779.22` | `128.80` | `7.09x` |
|| [Gqlgen] | `396.38` | `248.90` | `3.60x` |
|| [Netflix DGS] | `190.64` | `507.64` | `1.73x` |
|| [Apollo GraphQL] | `131.28` | `699.89` | `1.19x` |
|| [Hasura] | `109.95` | `851.67` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,698.20` | `3.06` | `71.94x` |
|| [async-graphql] | `5,142.55` | `19.51` | `11.31x` |
|| [Caliban] | `4,756.83` | `21.60` | `10.47x` |
|| [Gqlgen] | `1,132.18` | `96.72` | `2.49x` |
|| [GraphQL JIT] | `1,129.84` | `88.33` | `2.49x` |
|| [Apollo GraphQL] | `897.61` | `111.86` | `1.97x` |
|| [Netflix DGS] | `816.24` | `123.50` | `1.80x` |
|| [Hasura] | `454.50` | `239.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,272.70` | `2.48` | `26.56x` |
|| [Caliban] | `33,911.60` | `2.96` | `22.36x` |
|| [Gqlgen] | `24,155.90` | `9.51` | `15.93x` |
|| [async-graphql] | `23,969.90` | `4.20` | `15.81x` |
|| [GraphQL JIT] | `4,565.25` | `21.85` | `3.01x` |
|| [Netflix DGS] | `4,205.86` | `28.40` | `2.77x` |
|| [Apollo GraphQL] | `4,091.21` | `27.19` | `2.70x` |
|| [Hasura] | `1,516.39` | `66.15` | `1.00x` |

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
