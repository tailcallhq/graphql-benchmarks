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
|| [Tailcall] | `21,413.20` | `4.66` | `171.86x` |
|| [GraphQL JIT] | `1,074.95` | `92.51` | `8.63x` |
|| [async-graphql] | `1,001.21` | `99.16` | `8.04x` |
|| [Caliban] | `760.35` | `131.98` | `6.10x` |
|| [Gqlgen] | `397.58` | `248.12` | `3.19x` |
|| [Netflix DGS] | `192.78` | `500.55` | `1.55x` |
|| [Apollo GraphQL] | `128.18` | `713.87` | `1.03x` |
|| [Hasura] | `124.60` | `695.69` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,641.10` | `3.07` | `77.38x` |
|| [async-graphql] | `5,215.06` | `19.20` | `12.36x` |
|| [Caliban] | `4,701.64` | `21.85` | `11.15x` |
|| [Gqlgen] | `1,121.19` | `98.43` | `2.66x` |
|| [GraphQL JIT] | `1,099.32` | `90.80` | `2.61x` |
|| [Apollo GraphQL] | `855.72` | `117.49` | `2.03x` |
|| [Netflix DGS] | `812.26` | `124.36` | `1.93x` |
|| [Hasura] | `421.82` | `240.45` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,412.90` | `2.54` | `24.84x` |
|| [Caliban] | `32,731.80` | `3.08` | `20.63x` |
|| [Gqlgen] | `24,507.40` | `8.20` | `15.45x` |
|| [async-graphql] | `24,051.50` | `4.18` | `15.16x` |
|| [GraphQL JIT] | `4,555.57` | `21.89` | `2.87x` |
|| [Netflix DGS] | `4,184.23` | `28.58` | `2.64x` |
|| [Apollo GraphQL] | `3,955.34` | `27.88` | `2.49x` |
|| [Hasura] | `1,586.59` | `65.45` | `1.00x` |

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
