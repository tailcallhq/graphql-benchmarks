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
|| [Tailcall] | `28,759.30` | `3.47` | `210.66x` |
|| [async-graphql] | `2,041.81` | `49.09` | `14.96x` |
|| [Caliban] | `1,693.29` | `58.87` | `12.40x` |
|| [GraphQL JIT] | `1,342.65` | `74.16` | `9.84x` |
|| [Gqlgen] | `777.68` | `127.57` | `5.70x` |
|| [Netflix DGS] | `370.09` | `152.53` | `2.71x` |
|| [Apollo GraphQL] | `268.73` | `366.07` | `1.97x` |
|| [Hasura] | `136.52` | `638.20` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,783.30` | `1.72` | `71.47x` |
|| [async-graphql] | `9,956.37` | `10.12` | `12.31x` |
|| [Caliban] | `9,556.26` | `10.84` | `11.82x` |
|| [Gqlgen] | `2,181.67` | `47.51` | `2.70x` |
|| [Apollo GraphQL] | `1,756.06` | `56.88` | `2.17x` |
|| [Netflix DGS] | `1,612.80` | `69.74` | `1.99x` |
|| [GraphQL JIT] | `1,397.20` | `71.47` | `1.73x` |
|| [Hasura] | `808.53` | `123.41` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `70,273.90` | `1.06` | `27.86x` |
|| [Tailcall] | `59,465.90` | `1.69` | `23.58x` |
|| [async-graphql] | `48,444.40` | `2.07` | `19.21x` |
|| [Gqlgen] | `47,129.60` | `5.28` | `18.68x` |
|| [Netflix DGS] | `8,294.04` | `14.40` | `3.29x` |
|| [Apollo GraphQL] | `8,138.51` | `12.43` | `3.23x` |
|| [GraphQL JIT] | `5,253.88` | `19.01` | `2.08x` |
|| [Hasura] | `2,522.34` | `39.60` | `1.00x` |

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
