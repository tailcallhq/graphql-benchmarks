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
|| [Tailcall] | `21,963.30` | `4.55` | `184.82x` |
|| [GraphQL JIT] | `1,117.92` | `89.01` | `9.41x` |
|| [async-graphql] | `964.15` | `102.99` | `8.11x` |
|| [Caliban] | `745.57` | `134.81` | `6.27x` |
|| [Gqlgen] | `379.72` | `259.54` | `3.20x` |
|| [Netflix DGS] | `183.47` | `530.18` | `1.54x` |
|| [Apollo GraphQL] | `128.70` | `706.42` | `1.08x` |
|| [Hasura] | `118.84` | `786.24` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,377.80` | `2.99` | `73.39x` |
|| [async-graphql] | `5,021.26` | `19.92` | `11.04x` |
|| [Caliban] | `4,814.81` | `21.27` | `10.59x` |
|| [GraphQL JIT] | `1,156.58` | `86.28` | `2.54x` |
|| [Gqlgen] | `1,109.94` | `99.01` | `2.44x` |
|| [Apollo GraphQL] | `892.23` | `112.44` | `1.96x` |
|| [Netflix DGS] | `798.08` | `126.20` | `1.75x` |
|| [Hasura] | `454.78` | `228.14` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,905.40` | `2.45` | `27.66x` |
|| [Caliban] | `33,481.70` | `3.01` | `22.64x` |
|| [Gqlgen] | `24,619.50` | `9.62` | `16.65x` |
|| [async-graphql] | `23,514.20` | `4.27` | `15.90x` |
|| [GraphQL JIT] | `4,621.32` | `21.59` | `3.13x` |
|| [Netflix DGS] | `4,158.84` | `28.77` | `2.81x` |
|| [Apollo GraphQL] | `4,073.13` | `27.31` | `2.75x` |
|| [Hasura] | `1,478.75` | `68.22` | `1.00x` |

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
