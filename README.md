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
|| [Tailcall] | `7,766.21` | `12.86` | `63.96x` |
|| [GraphQL JIT] | `1,143.11` | `86.98` | `9.41x` |
|| [async-graphql] | `1,011.95` | `98.75` | `8.33x` |
|| [Caliban] | `769.96` | `130.02` | `6.34x` |
|| [Gqlgen] | `399.93` | `246.38` | `3.29x` |
|| [Netflix DGS] | `185.96` | `521.37` | `1.53x` |
|| [Apollo GraphQL] | `131.19` | `699.08` | `1.08x` |
|| [Hasura] | `121.43` | `763.77` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `14,407.80` | `6.98` | `31.49x` |
|| [async-graphql] | `5,238.40` | `19.12` | `11.45x` |
|| [Caliban] | `4,761.33` | `21.53` | `10.41x` |
|| [GraphQL JIT] | `1,187.43` | `84.02` | `2.60x` |
|| [Gqlgen] | `1,124.00` | `97.67` | `2.46x` |
|| [Apollo GraphQL] | `885.37` | `113.37` | `1.94x` |
|| [Netflix DGS] | `801.74` | `125.37` | `1.75x` |
|| [Hasura] | `457.55` | `238.45` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,877.30` | `3.03` | `20.61x` |
|| [Gqlgen] | `24,799.50` | `9.09` | `15.54x` |
|| [async-graphql] | `24,145.10` | `4.14` | `15.13x` |
|| [Tailcall] | `20,696.40` | `4.85` | `12.97x` |
|| [GraphQL JIT] | `4,626.07` | `21.56` | `2.90x` |
|| [Netflix DGS] | `4,187.50` | `27.89` | `2.62x` |
|| [Apollo GraphQL] | `3,968.37` | `28.13` | `2.49x` |
|| [Hasura] | `1,595.47` | `63.07` | `1.00x` |

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
