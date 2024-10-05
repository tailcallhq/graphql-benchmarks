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
|| [Tailcall] | `13,507.60` | `7.37` | `118.03x` |
|| [async-graphql] | `1,106.54` | `89.86` | `9.67x` |
|| [GraphQL JIT] | `1,101.30` | `90.29` | `9.62x` |
|| [Caliban] | `859.33` | `116.33` | `7.51x` |
|| [Gqlgen] | `376.76` | `261.64` | `3.29x` |
|| [Netflix DGS] | `188.23` | `520.26` | `1.64x` |
|| [Apollo GraphQL] | `134.44` | `686.89` | `1.17x` |
|| [Hasura] | `114.44` | `748.44` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,458.30` | `4.63` | `45.81x` |
|| [async-graphql] | `5,444.44` | `18.39` | `11.62x` |
|| [Caliban] | `5,437.29` | `18.44` | `11.61x` |
|| [GraphQL JIT] | `1,133.85` | `88.03` | `2.42x` |
|| [Gqlgen] | `1,057.36` | `103.88` | `2.26x` |
|| [Apollo GraphQL] | `910.19` | `110.36` | `1.94x` |
|| [Netflix DGS] | `814.87` | `152.85` | `1.74x` |
|| [Hasura] | `468.37` | `222.36` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,241.60` | `2.10` | `29.58x` |
|| [async-graphql] | `25,490.60` | `3.91` | `16.31x` |
|| [Gqlgen] | `24,804.70` | `5.34` | `15.87x` |
|| [Tailcall] | `21,475.50` | `4.67` | `13.74x` |
|| [GraphQL JIT] | `4,503.91` | `22.16` | `2.88x` |
|| [Netflix DGS] | `4,175.36` | `28.04` | `2.67x` |
|| [Apollo GraphQL] | `4,101.91` | `27.95` | `2.62x` |
|| [Hasura] | `1,563.25` | `63.76` | `1.00x` |

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
