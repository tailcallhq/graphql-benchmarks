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
|| [Tailcall] | `29,769.90` | `3.35` | `339.83x` |
|| [async-graphql] | `1,957.79` | `51.19` | `22.35x` |
|| [Caliban] | `1,698.04` | `58.62` | `19.38x` |
|| [GraphQL JIT] | `1,340.35` | `74.32` | `15.30x` |
|| [Gqlgen] | `791.88` | `125.39` | `9.04x` |
|| [Netflix DGS] | `369.08` | `168.10` | `4.21x` |
|| [Apollo GraphQL] | `267.88` | `367.05` | `3.06x` |
|| [Hasura] | `87.60` | `588.44` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,463.80` | `1.70` | `71.49x` |
|| [async-graphql] | `9,810.24` | `10.31` | `12.00x` |
|| [Caliban] | `9,648.84` | `10.72` | `11.80x` |
|| [Gqlgen] | `2,199.44` | `47.03` | `2.69x` |
|| [Apollo GraphQL] | `1,742.74` | `57.30` | `2.13x` |
|| [Netflix DGS] | `1,608.82` | `70.23` | `1.97x` |
|| [GraphQL JIT] | `1,410.09` | `70.82` | `1.72x` |
|| [Hasura] | `817.79` | `122.03` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,001.90` | `1.05` | `27.91x` |
|| [Tailcall] | `59,310.50` | `1.70` | `23.99x` |
|| [async-graphql] | `47,447.00` | `2.11` | `19.19x` |
|| [Gqlgen] | `47,298.20` | `5.31` | `19.13x` |
|| [Netflix DGS] | `8,268.66` | `14.50` | `3.34x` |
|| [Apollo GraphQL] | `8,103.87` | `12.54` | `3.28x` |
|| [GraphQL JIT] | `5,273.47` | `18.94` | `2.13x` |
|| [Hasura] | `2,472.03` | `40.34` | `1.00x` |

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
