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
|| [Tailcall] | `13,731.20` | `7.25` | `120.54x` |
|| [GraphQL JIT] | `1,106.95` | `89.86` | `9.72x` |
|| [async-graphql] | `1,067.80` | `93.09` | `9.37x` |
|| [Caliban] | `838.63` | `118.94` | `7.36x` |
|| [Gqlgen] | `401.09` | `245.74` | `3.52x` |
|| [Netflix DGS] | `179.10` | `546.66` | `1.57x` |
|| [Apollo GraphQL] | `128.80` | `709.02` | `1.13x` |
|| [Hasura] | `113.91` | `786.26` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,644.50` | `4.60` | `47.84x` |
|| [Caliban] | `5,355.89` | `18.75` | `11.84x` |
|| [async-graphql] | `5,338.53` | `18.71` | `11.80x` |
|| [GraphQL JIT] | `1,148.54` | `86.89` | `2.54x` |
|| [Gqlgen] | `1,112.20` | `99.16` | `2.46x` |
|| [Apollo GraphQL] | `875.08` | `114.81` | `1.93x` |
|| [Netflix DGS] | `794.14` | `151.63` | `1.76x` |
|| [Hasura] | `452.46` | `226.75` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,987.60` | `2.02` | `29.35x` |
|| [async-graphql] | `25,722.70` | `3.87` | `15.73x` |
|| [Gqlgen] | `25,712.40` | `4.93` | `15.73x` |
|| [Tailcall] | `21,007.30` | `4.77` | `12.85x` |
|| [GraphQL JIT] | `4,506.52` | `22.15` | `2.76x` |
|| [Netflix DGS] | `4,057.47` | `28.93` | `2.48x` |
|| [Apollo GraphQL] | `3,955.96` | `29.81` | `2.42x` |
|| [Hasura] | `1,634.88` | `63.87` | `1.00x` |

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
