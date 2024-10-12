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
|| [Tailcall] | `13,569.40` | `7.36` | `114.66x` |
|| [GraphQL JIT] | `1,103.27` | `90.02` | `9.32x` |
|| [async-graphql] | `983.81` | `101.20` | `8.31x` |
|| [Caliban] | `748.66` | `133.32` | `6.33x` |
|| [Gqlgen] | `398.64` | `247.38` | `3.37x` |
|| [Netflix DGS] | `185.36` | `522.25` | `1.57x` |
|| [Apollo GraphQL] | `133.16` | `689.28` | `1.13x` |
|| [Hasura] | `118.34` | `707.89` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,017.60` | `4.76` | `48.92x` |
|| [async-graphql] | `5,157.17` | `19.41` | `12.00x` |
|| [Caliban] | `4,666.74` | `21.98` | `10.86x` |
|| [GraphQL JIT] | `1,150.18` | `86.78` | `2.68x` |
|| [Gqlgen] | `1,128.04` | `97.00` | `2.63x` |
|| [Apollo GraphQL] | `912.37` | `109.88` | `2.12x` |
|| [Netflix DGS] | `794.07` | `126.34` | `1.85x` |
|| [Hasura] | `429.62` | `239.14` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,788.70` | `3.07` | `21.16x` |
|| [Gqlgen] | `24,166.90` | `9.19` | `15.60x` |
|| [async-graphql] | `23,388.90` | `4.29` | `15.09x` |
|| [Tailcall] | `20,800.90` | `4.83` | `13.42x` |
|| [GraphQL JIT] | `4,556.10` | `21.90` | `2.94x` |
|| [Apollo GraphQL] | `4,177.01` | `26.29` | `2.70x` |
|| [Netflix DGS] | `4,121.48` | `28.65` | `2.66x` |
|| [Hasura] | `1,549.60` | `67.12` | `1.00x` |

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
