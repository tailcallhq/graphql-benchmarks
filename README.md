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
|| [Tailcall] | `13,680.50` | `7.28` | `122.96x` |
|| [GraphQL JIT] | `1,090.03` | `91.30` | `9.80x` |
|| [async-graphql] | `1,052.70` | `94.46` | `9.46x` |
|| [Caliban] | `855.54` | `117.04` | `7.69x` |
|| [Gqlgen] | `380.78` | `258.93` | `3.42x` |
|| [Netflix DGS] | `191.37` | `518.40` | `1.72x` |
|| [Apollo GraphQL] | `131.67` | `699.30` | `1.18x` |
|| [Hasura] | `111.26` | `800.66` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,906.70` | `4.54` | `51.75x` |
|| [Caliban] | `5,482.13` | `18.30` | `12.95x` |
|| [async-graphql] | `5,337.76` | `18.76` | `12.61x` |
|| [GraphQL JIT] | `1,147.39` | `86.97` | `2.71x` |
|| [Gqlgen] | `1,087.03` | `100.77` | `2.57x` |
|| [Apollo GraphQL] | `893.93` | `112.42` | `2.11x` |
|| [Netflix DGS] | `817.48` | `154.56` | `1.93x` |
|| [Hasura] | `423.30` | `235.55` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,408.10` | `2.09` | `30.28x` |
|| [Gqlgen] | `25,719.70` | `5.02` | `16.78x` |
|| [async-graphql] | `25,626.80` | `3.90` | `16.72x` |
|| [Tailcall] | `21,416.60` | `4.69` | `13.97x` |
|| [GraphQL JIT] | `4,452.82` | `22.41` | `2.91x` |
|| [Netflix DGS] | `4,135.70` | `27.89` | `2.70x` |
|| [Apollo GraphQL] | `4,035.32` | `28.88` | `2.63x` |
|| [Hasura] | `1,532.73` | `65.78` | `1.00x` |

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
