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
|| [Tailcall] | `29,923.80` | `3.33` | `110.64x` |
|| [async-graphql] | `1,864.27` | `53.64` | `6.89x` |
|| [Caliban] | `1,598.72` | `62.26` | `5.91x` |
|| [Hasura] | `1,465.91` | `67.96` | `5.42x` |
|| [GraphQL JIT] | `1,322.43` | `75.29` | `4.89x` |
|| [Gqlgen] | `750.01` | `132.28` | `2.77x` |
|| [Netflix DGS] | `363.69` | `171.58` | `1.34x` |
|| [Apollo GraphQL] | `270.46` | `363.56` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,113.40` | `1.60` | `45.44x` |
|| [async-graphql] | `9,494.56` | `10.68` | `6.95x` |
|| [Caliban] | `9,409.47` | `10.99` | `6.88x` |
|| [Hasura] | `2,478.16` | `40.33` | `1.81x` |
|| [Gqlgen] | `2,172.04` | `47.67` | `1.59x` |
|| [Apollo GraphQL] | `1,762.80` | `56.65` | `1.29x` |
|| [Netflix DGS] | `1,614.99` | `69.08` | `1.18x` |
|| [GraphQL JIT] | `1,367.03` | `73.03` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,822.10` | `1.03` | `27.50x` |
|| [Tailcall] | `64,287.90` | `1.57` | `25.32x` |
|| [async-graphql] | `52,013.70` | `2.01` | `20.49x` |
|| [Gqlgen] | `48,131.50` | `4.86` | `18.96x` |
|| [Netflix DGS] | `8,374.86` | `14.27` | `3.30x` |
|| [Apollo GraphQL] | `8,056.88` | `12.55` | `3.17x` |
|| [GraphQL JIT] | `5,139.03` | `19.43` | `2.02x` |
|| [Hasura] | `2,538.72` | `39.32` | `1.00x` |

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
