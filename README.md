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
|| [Tailcall] | `7,736.42` | `12.90` | `64.99x` |
|| [GraphQL JIT] | `1,124.65` | `88.33` | `9.45x` |
|| [async-graphql] | `1,017.34` | `97.68` | `8.55x` |
|| [Caliban] | `737.22` | `136.40` | `6.19x` |
|| [Gqlgen] | `393.69` | `250.48` | `3.31x` |
|| [Netflix DGS] | `191.00` | `508.26` | `1.60x` |
|| [Apollo GraphQL] | `130.04` | `703.56` | `1.09x` |
|| [Hasura] | `119.03` | `747.51` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `14,147.80` | `7.07` | `33.44x` |
|| [async-graphql] | `5,293.37` | `18.92` | `12.51x` |
|| [Caliban] | `4,765.38` | `21.48` | `11.26x` |
|| [GraphQL JIT] | `1,166.68` | `85.54` | `2.76x` |
|| [Gqlgen] | `1,118.09` | `98.00` | `2.64x` |
|| [Apollo GraphQL] | `899.62` | `111.59` | `2.13x` |
|| [Netflix DGS] | `812.39` | `123.69` | `1.92x` |
|| [Hasura] | `423.05` | `237.69` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,084.60` | `3.12` | `20.68x` |
|| [Gqlgen] | `24,110.70` | `9.73` | `15.54x` |
|| [async-graphql] | `23,786.20` | `4.21` | `15.33x` |
|| [Tailcall] | `19,662.30` | `5.10` | `12.67x` |
|| [GraphQL JIT] | `4,581.88` | `21.78` | `2.95x` |
|| [Netflix DGS] | `4,215.92` | `28.21` | `2.72x` |
|| [Apollo GraphQL] | `4,032.61` | `27.34` | `2.60x` |
|| [Hasura] | `1,551.65` | `65.75` | `1.00x` |

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
