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
|| [Tailcall] | `10,771.40` | `9.26` | `91.71x` |
|| [GraphQL JIT] | `1,097.86` | `90.57` | `9.35x` |
|| [async-graphql] | `1,020.05` | `97.37` | `8.68x` |
|| [Caliban] | `772.84` | `129.04` | `6.58x` |
|| [Gqlgen] | `405.54` | `243.19` | `3.45x` |
|| [Netflix DGS] | `185.14` | `521.03` | `1.58x` |
|| [Apollo GraphQL] | `128.30` | `710.42` | `1.09x` |
|| [Hasura] | `117.45` | `722.09` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,529.60` | `4.64` | `52.19x` |
|| [async-graphql] | `5,250.25` | `19.05` | `12.73x` |
|| [Caliban] | `4,817.49` | `21.30` | `11.68x` |
|| [Gqlgen] | `1,120.21` | `97.91` | `2.72x` |
|| [GraphQL JIT] | `1,080.49` | `92.44` | `2.62x` |
|| [Apollo GraphQL] | `867.70` | `115.79` | `2.10x` |
|| [Netflix DGS] | `798.06` | `125.89` | `1.93x` |
|| [Hasura] | `412.56` | `243.58` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,086.90` | `3.03` | `21.18x` |
|| [Tailcall] | `31,399.20` | `3.25` | `20.10x` |
|| [Gqlgen] | `23,788.90` | `9.60` | `15.23x` |
|| [async-graphql] | `23,667.00` | `4.27` | `15.15x` |
|| [GraphQL JIT] | `4,336.89` | `23.00` | `2.78x` |
|| [Netflix DGS] | `4,135.48` | `28.94` | `2.65x` |
|| [Apollo GraphQL] | `3,877.54` | `29.27` | `2.48x` |
|| [Hasura] | `1,561.84` | `65.74` | `1.00x` |

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
