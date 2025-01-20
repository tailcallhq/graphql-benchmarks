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
|| [Tailcall] | `22,707.10` | `4.32` | `202.87x` |
|| [GraphQL JIT] | `1,093.35` | `90.94` | `9.77x` |
|| [async-graphql] | `1,065.50` | `93.27` | `9.52x` |
|| [Caliban] | `850.74` | `118.12` | `7.60x` |
|| [Gqlgen] | `392.52` | `251.33` | `3.51x` |
|| [Netflix DGS] | `185.18` | `529.01` | `1.65x` |
|| [Apollo GraphQL] | `133.67` | `689.20` | `1.19x` |
|| [Hasura] | `111.93` | `803.33` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `35,878.00` | `2.73` | `86.23x` |
|| [Caliban] | `5,414.77` | `18.54` | `13.01x` |
|| [async-graphql] | `5,176.42` | `19.31` | `12.44x` |
|| [GraphQL JIT] | `1,146.61` | `87.04` | `2.76x` |
|| [Gqlgen] | `1,094.44` | `100.92` | `2.63x` |
|| [Apollo GraphQL] | `913.23` | `109.96` | `2.19x` |
|| [Netflix DGS] | `797.52` | `160.64` | `1.92x` |
|| [Hasura] | `416.07` | `240.50` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,710.20` | `2.03` | `29.48x` |
|| [Tailcall] | `46,511.30` | `2.10` | `28.74x` |
|| [Gqlgen] | `25,362.20` | `5.10` | `15.67x` |
|| [async-graphql] | `25,050.90` | `3.98` | `15.48x` |
|| [GraphQL JIT] | `4,544.55` | `21.96` | `2.81x` |
|| [Apollo GraphQL] | `4,130.25` | `27.53` | `2.55x` |
|| [Netflix DGS] | `4,127.97` | `28.09` | `2.55x` |
|| [Hasura] | `1,618.49` | `61.61` | `1.00x` |

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
