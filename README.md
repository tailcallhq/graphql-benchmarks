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
|| [Tailcall] | `20,559.20` | `4.85` | `187.37x` |
|| [GraphQL JIT] | `1,082.18` | `91.92` | `9.86x` |
|| [async-graphql] | `1,023.44` | `96.92` | `9.33x` |
|| [Caliban] | `706.89` | `141.73` | `6.44x` |
|| [Gqlgen] | `388.17` | `254.10` | `3.54x` |
|| [Netflix DGS] | `190.54` | `508.12` | `1.74x` |
|| [Apollo GraphQL] | `134.23` | `689.38` | `1.22x` |
|| [Hasura] | `109.73` | `810.88` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,326.60` | `3.10` | `73.10x` |
|| [async-graphql] | `5,208.92` | `19.23` | `11.78x` |
|| [Caliban] | `4,778.08` | `21.45` | `10.80x` |
|| [Gqlgen] | `1,113.87` | `97.66` | `2.52x` |
|| [GraphQL JIT] | `1,107.91` | `90.08` | `2.51x` |
|| [Apollo GraphQL] | `912.66` | `109.95` | `2.06x` |
|| [Netflix DGS] | `809.47` | `124.58` | `1.83x` |
|| [Hasura] | `442.23` | `225.84` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,348.70` | `2.54` | `25.74x` |
|| [Caliban] | `34,079.40` | `2.95` | `22.29x` |
|| [Gqlgen] | `24,031.90` | `9.38` | `15.72x` |
|| [async-graphql] | `23,407.70` | `4.31` | `15.31x` |
|| [GraphQL JIT] | `4,506.17` | `22.14` | `2.95x` |
|| [Netflix DGS] | `4,244.47` | `28.12` | `2.78x` |
|| [Apollo GraphQL] | `4,127.37` | `26.66` | `2.70x` |
|| [Hasura] | `1,528.70` | `65.45` | `1.00x` |

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
