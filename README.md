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
|| [Tailcall] | `29,861.00` | `3.34` | `279.34x` |
|| [async-graphql] | `1,966.10` | `50.96` | `18.39x` |
|| [Caliban] | `1,677.23` | `59.37` | `15.69x` |
|| [GraphQL JIT] | `1,341.58` | `74.25` | `12.55x` |
|| [Gqlgen] | `798.67` | `124.21` | `7.47x` |
|| [Netflix DGS] | `370.11` | `158.18` | `3.46x` |
|| [Apollo GraphQL] | `266.67` | `368.77` | `2.49x` |
|| [Hasura] | `106.90` | `601.96` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,976.40` | `1.69` | `69.49x` |
|| [async-graphql] | `9,693.88` | `10.53` | `11.42x` |
|| [Caliban] | `9,438.91` | `10.96` | `11.12x` |
|| [Gqlgen] | `2,204.73` | `47.12` | `2.60x` |
|| [Apollo GraphQL] | `1,792.54` | `55.72` | `2.11x` |
|| [Netflix DGS] | `1,610.67` | `69.73` | `1.90x` |
|| [GraphQL JIT] | `1,392.02` | `71.74` | `1.64x` |
|| [Hasura] | `848.76` | `117.55` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,254.40` | `1.18` | `25.82x` |
|| [Tailcall] | `60,083.90` | `1.67` | `23.42x` |
|| [async-graphql] | `47,962.60` | `2.14` | `18.69x` |
|| [Gqlgen] | `47,703.60` | `5.09` | `18.59x` |
|| [Netflix DGS] | `8,243.49` | `14.63` | `3.21x` |
|| [Apollo GraphQL] | `8,163.34` | `12.44` | `3.18x` |
|| [GraphQL JIT] | `5,211.31` | `19.16` | `2.03x` |
|| [Hasura] | `2,566.02` | `38.89` | `1.00x` |

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
