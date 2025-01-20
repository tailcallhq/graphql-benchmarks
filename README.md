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
|| [Tailcall] | `22,403.70` | `4.38` | `201.24x` |
|| [GraphQL JIT] | `1,115.11` | `89.18` | `10.02x` |
|| [async-graphql] | `1,058.72` | `93.87` | `9.51x` |
|| [Caliban] | `812.39` | `123.95` | `7.30x` |
|| [Gqlgen] | `373.46` | `263.89` | `3.35x` |
|| [Netflix DGS] | `179.60` | `545.54` | `1.61x` |
|| [Apollo GraphQL] | `128.04` | `715.55` | `1.15x` |
|| [Hasura] | `111.33` | `785.47` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `35,142.90` | `2.79` | `78.51x` |
|| [Caliban] | `5,592.58` | `17.92` | `12.49x` |
|| [async-graphql] | `5,199.96` | `19.23` | `11.62x` |
|| [GraphQL JIT] | `1,141.02` | `87.46` | `2.55x` |
|| [Gqlgen] | `1,060.39` | `103.45` | `2.37x` |
|| [Apollo GraphQL] | `891.00` | `112.74` | `1.99x` |
|| [Netflix DGS] | `787.66` | `165.02` | `1.76x` |
|| [Hasura] | `447.62` | `229.63` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,819.20` | `2.07` | `29.16x` |
|| [Tailcall] | `44,749.20` | `2.18` | `27.87x` |
|| [async-graphql] | `25,585.60` | `3.90` | `15.94x` |
|| [Gqlgen] | `25,159.20` | `5.10` | `15.67x` |
|| [GraphQL JIT] | `4,597.25` | `21.71` | `2.86x` |
|| [Apollo GraphQL] | `4,082.86` | `28.16` | `2.54x` |
|| [Netflix DGS] | `4,017.37` | `29.31` | `2.50x` |
|| [Hasura] | `1,605.38` | `62.36` | `1.00x` |

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
