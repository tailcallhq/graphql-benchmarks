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
|| [Tailcall] | `29,593.00` | `3.36` | `107.90x` |
|| [async-graphql] | `1,740.39` | `57.51` | `6.35x` |
|| [Caliban] | `1,538.08` | `64.78` | `5.61x` |
|| [Hasura] | `1,479.22` | `67.51` | `5.39x` |
|| [GraphQL JIT] | `1,332.21` | `78.92` | `4.86x` |
|| [Gqlgen] | `766.87` | `129.39` | `2.80x` |
|| [Netflix DGS] | `358.35` | `165.86` | `1.31x` |
|| [Apollo GraphQL] | `274.26` | `358.21` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,646.70` | `1.61` | `43.98x` |
|| [Caliban] | `9,256.21` | `11.15` | `6.60x` |
|| [async-graphql] | `8,621.02` | `11.74` | `6.15x` |
|| [Hasura] | `2,463.09` | `40.58` | `1.76x` |
|| [Gqlgen] | `2,164.30` | `47.79` | `1.54x` |
|| [Apollo GraphQL] | `1,711.08` | `58.37` | `1.22x` |
|| [Netflix DGS] | `1,578.04` | `69.80` | `1.13x` |
|| [GraphQL JIT] | `1,401.73` | `72.48` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,962.20` | `1.10` | `26.85x` |
|| [Tailcall] | `63,508.70` | `1.59` | `25.09x` |
|| [async-graphql] | `49,114.70` | `2.14` | `19.41x` |
|| [Gqlgen] | `47,983.00` | `4.97` | `18.96x` |
|| [Netflix DGS] | `8,053.75` | `14.83` | `3.18x` |
|| [Apollo GraphQL] | `7,953.12` | `12.89` | `3.14x` |
|| [GraphQL JIT] | `5,178.18` | `27.52` | `2.05x` |
|| [Hasura] | `2,531.00` | `39.49` | `1.00x` |

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
