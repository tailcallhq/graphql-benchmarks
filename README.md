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
|| [Tailcall] | `18,800.20` | `5.31` | `158.92x` |
|| [GraphQL JIT] | `1,125.92` | `88.32` | `9.52x` |
|| [async-graphql] | `1,026.88` | `96.77` | `8.68x` |
|| [Caliban] | `649.24` | `154.39` | `5.49x` |
|| [Gqlgen] | `394.38` | `250.13` | `3.33x` |
|| [Netflix DGS] | `189.79` | `508.65` | `1.60x` |
|| [Apollo GraphQL] | `125.43` | `724.88` | `1.06x` |
|| [Hasura] | `118.30` | `746.06` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `29,421.20` | `3.40` | `62.90x` |
|| [async-graphql] | `5,260.78` | `19.04` | `11.25x` |
|| [Caliban] | `4,659.71` | `21.89` | `9.96x` |
|| [GraphQL JIT] | `1,163.57` | `85.75` | `2.49x` |
|| [Gqlgen] | `1,129.30` | `96.63` | `2.41x` |
|| [Apollo GraphQL] | `848.76` | `118.27` | `1.81x` |
|| [Netflix DGS] | `810.71` | `124.04` | `1.73x` |
|| [Hasura] | `467.75` | `227.25` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,359.80` | `2.60` | `24.63x` |
|| [Gqlgen] | `24,471.10` | `8.70` | `15.71x` |
|| [async-graphql] | `23,417.40` | `4.30` | `15.03x` |
|| [Tailcall] | `23,070.40` | `4.34` | `14.81x` |
|| [GraphQL JIT] | `4,560.84` | `21.88` | `2.93x` |
|| [Netflix DGS] | `4,272.67` | `28.36` | `2.74x` |
|| [Apollo GraphQL] | `3,893.00` | `28.87` | `2.50x` |
|| [Hasura] | `1,557.62` | `63.99` | `1.00x` |

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
