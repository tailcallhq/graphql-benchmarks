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
|| [Tailcall] | `8,189.24` | `12.18` | `67.71x` |
|| [GraphQL JIT] | `1,088.29` | `91.35` | `9.00x` |
|| [async-graphql] | `972.37` | `102.00` | `8.04x` |
|| [Caliban] | `826.64` | `121.16` | `6.83x` |
|| [Gqlgen] | `388.32` | `253.83` | `3.21x` |
|| [Netflix DGS] | `189.89` | `511.58` | `1.57x` |
|| [Apollo GraphQL] | `128.31` | `711.44` | `1.06x` |
|| [Hasura] | `120.95` | `750.93` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,777.70` | `6.33` | `35.43x` |
|| [async-graphql] | `5,246.08` | `19.07` | `11.78x` |
|| [Caliban] | `5,100.31` | `19.98` | `11.45x` |
|| [GraphQL JIT] | `1,137.60` | `87.76` | `2.55x` |
|| [Gqlgen] | `1,112.17` | `98.23` | `2.50x` |
|| [Apollo GraphQL] | `882.52` | `113.71` | `1.98x` |
|| [Netflix DGS] | `808.27` | `124.76` | `1.81x` |
|| [Hasura] | `445.36` | `226.22` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `34,440.00` | `2.91` | `22.17x` |
|| [Gqlgen] | `24,058.30` | `8.62` | `15.49x` |
|| [async-graphql] | `23,746.10` | `4.23` | `15.29x` |
|| [Tailcall] | `20,353.60` | `4.93` | `13.10x` |
|| [GraphQL JIT] | `4,466.85` | `22.33` | `2.88x` |
|| [Netflix DGS] | `4,153.90` | `28.79` | `2.67x` |
|| [Apollo GraphQL] | `4,025.95` | `27.53` | `2.59x` |
|| [Hasura] | `1,553.52` | `64.38` | `1.00x` |

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
