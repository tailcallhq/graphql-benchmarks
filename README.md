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
|| [Tailcall] | `29,564.90` | `3.37` | `123.54x` |
|| [async-graphql] | `2,043.91` | `49.59` | `8.54x` |
|| [Caliban] | `1,790.38` | `55.60` | `7.48x` |
|| [GraphQL JIT] | `1,286.36` | `77.40` | `5.37x` |
|| [Gqlgen] | `767.96` | `129.19` | `3.21x` |
|| [Netflix DGS] | `359.05` | `184.66` | `1.50x` |
|| [Apollo GraphQL] | `270.97` | `362.62` | `1.13x` |
|| [Hasura] | `239.32` | `417.44` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,015.30` | `1.69` | `82.57x` |
|| [async-graphql] | `10,335.90` | `9.77` | `14.46x` |
|| [Caliban] | `9,910.12` | `10.44` | `13.87x` |
|| [Gqlgen] | `2,124.62` | `48.78` | `2.97x` |
|| [Apollo GraphQL] | `1,773.91` | `56.29` | `2.48x` |
|| [Netflix DGS] | `1,568.91` | `71.22` | `2.20x` |
|| [GraphQL JIT] | `1,331.15` | `75.01` | `1.86x` |
|| [Hasura] | `714.73` | `140.60` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,258.30` | `1.13` | `27.75x` |
|| [Tailcall] | `59,299.50` | `1.70` | `24.83x` |
|| [async-graphql] | `48,619.80` | `2.07` | `20.36x` |
|| [Gqlgen] | `46,314.60` | `5.27` | `19.39x` |
|| [Netflix DGS] | `8,149.64` | `14.93` | `3.41x` |
|| [Apollo GraphQL] | `8,043.68` | `12.70` | `3.37x` |
|| [GraphQL JIT] | `5,111.38` | `19.54` | `2.14x` |
|| [Hasura] | `2,388.11` | `41.73` | `1.00x` |

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
