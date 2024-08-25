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
|| [Tailcall] | `27,340.10` | `3.64` | `125.73x` |
|| [async-graphql] | `2,009.92` | `50.46` | `9.24x` |
|| [Caliban] | `1,788.33` | `55.65` | `8.22x` |
|| [GraphQL JIT] | `1,287.40` | `77.33` | `5.92x` |
|| [Gqlgen] | `796.45` | `124.60` | `3.66x` |
|| [Netflix DGS] | `366.40` | `159.89` | `1.68x` |
|| [Apollo GraphQL] | `274.63` | `357.28` | `1.26x` |
|| [Hasura] | `217.45` | `451.43` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `56,578.30` | `1.76` | `83.73x` |
|| [async-graphql] | `10,311.00` | `9.82` | `15.26x` |
|| [Caliban] | `10,033.10` | `10.27` | `14.85x` |
|| [Gqlgen] | `2,219.34` | `46.78` | `3.28x` |
|| [Apollo GraphQL] | `1,787.09` | `55.89` | `2.64x` |
|| [Netflix DGS] | `1,584.38` | `70.60` | `2.34x` |
|| [GraphQL JIT] | `1,314.71` | `75.95` | `1.95x` |
|| [Hasura] | `675.74` | `148.78` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,950.30` | `1.04` | `29.49x` |
|| [Tailcall] | `58,717.20` | `1.72` | `24.75x` |
|| [async-graphql] | `48,105.70` | `2.21` | `20.28x` |
|| [Gqlgen] | `47,799.80` | `4.96` | `20.15x` |
|| [Apollo GraphQL] | `8,208.90` | `12.48` | `3.46x` |
|| [Netflix DGS] | `8,202.87` | `14.71` | `3.46x` |
|| [GraphQL JIT] | `5,051.01` | `19.77` | `2.13x` |
|| [Hasura] | `2,372.21` | `42.30` | `1.00x` |

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
