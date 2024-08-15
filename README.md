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
|| [Tailcall] | `29,917.60` | `3.33` | `129.90x` |
|| [async-graphql] | `2,019.32` | `50.03` | `8.77x` |
|| [Caliban] | `1,702.32` | `58.62` | `7.39x` |
|| [GraphQL JIT] | `1,314.77` | `75.73` | `5.71x` |
|| [Gqlgen] | `801.20` | `123.89` | `3.48x` |
|| [Netflix DGS] | `365.94` | `177.25` | `1.59x` |
|| [Apollo GraphQL] | `274.45` | `357.63` | `1.19x` |
|| [Hasura] | `230.31` | `439.81` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,170.00` | `1.68` | `83.40x` |
|| [async-graphql] | `10,210.40` | `9.83` | `14.39x` |
|| [Caliban] | `9,640.51` | `10.73` | `13.59x` |
|| [Gqlgen] | `2,209.52` | `46.82` | `3.11x` |
|| [Apollo GraphQL] | `1,742.01` | `57.31` | `2.46x` |
|| [Netflix DGS] | `1,612.25` | `69.73` | `2.27x` |
|| [GraphQL JIT] | `1,347.73` | `74.10` | `1.90x` |
|| [Hasura] | `709.49` | `140.59` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,383.20` | `1.09` | `27.38x` |
|| [Tailcall] | `59,401.60` | `1.70` | `24.14x` |
|| [async-graphql] | `47,647.90` | `2.23` | `19.36x` |
|| [Gqlgen] | `47,298.50` | `5.24` | `19.22x` |
|| [Netflix DGS] | `8,303.81` | `14.54` | `3.37x` |
|| [Apollo GraphQL] | `8,048.13` | `12.58` | `3.27x` |
|| [GraphQL JIT] | `5,042.14` | `19.80` | `2.05x` |
|| [Hasura] | `2,460.93` | `40.57` | `1.00x` |

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
