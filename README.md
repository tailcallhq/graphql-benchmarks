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
|| [Tailcall] | `21,505.90` | `4.64` | `179.71x` |
|| [GraphQL JIT] | `1,147.64` | `86.66` | `9.59x` |
|| [async-graphql] | `960.56` | `103.46` | `8.03x` |
|| [Caliban] | `815.48` | `123.63` | `6.81x` |
|| [Gqlgen] | `393.00` | `251.01` | `3.28x` |
|| [Netflix DGS] | `189.14` | `511.60` | `1.58x` |
|| [Apollo GraphQL] | `129.75` | `705.32` | `1.08x` |
|| [Hasura] | `119.67` | `728.84` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,889.30` | `3.04` | `70.76x` |
|| [async-graphql] | `5,051.46` | `19.81` | `10.87x` |
|| [Caliban] | `4,909.66` | `20.89` | `10.56x` |
|| [GraphQL JIT] | `1,176.11` | `84.87` | `2.53x` |
|| [Gqlgen] | `1,085.34` | `101.33` | `2.33x` |
|| [Apollo GraphQL] | `875.43` | `114.68` | `1.88x` |
|| [Netflix DGS] | `807.98` | `124.11` | `1.74x` |
|| [Hasura] | `464.82` | `215.29` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,737.10` | `2.51` | `27.10x` |
|| [Caliban] | `32,617.30` | `3.06` | `22.24x` |
|| [Gqlgen] | `24,468.00` | `9.79` | `16.69x` |
|| [async-graphql] | `23,322.10` | `4.30` | `15.91x` |
|| [GraphQL JIT] | `4,654.49` | `21.43` | `3.17x` |
|| [Netflix DGS] | `4,174.09` | `28.32` | `2.85x` |
|| [Apollo GraphQL] | `3,962.47` | `28.60` | `2.70x` |
|| [Hasura] | `1,466.31` | `68.03` | `1.00x` |

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
