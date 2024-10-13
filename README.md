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
|| [Tailcall] | `14,084.50` | `7.09` | `117.52x` |
|| [GraphQL JIT] | `1,135.55` | `87.60` | `9.48x` |
|| [async-graphql] | `1,002.77` | `98.95` | `8.37x` |
|| [Caliban] | `735.26` | `136.75` | `6.14x` |
|| [Gqlgen] | `392.47` | `251.22` | `3.27x` |
|| [Netflix DGS] | `183.77` | `526.74` | `1.53x` |
|| [Apollo GraphQL] | `132.90` | `690.00` | `1.11x` |
|| [Hasura] | `119.84` | `747.80` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,455.00` | `4.66` | `48.95x` |
|| [async-graphql] | `5,248.46` | `19.10` | `11.97x` |
|| [Caliban] | `4,921.04` | `20.79` | `11.23x` |
|| [GraphQL JIT] | `1,179.38` | `84.63` | `2.69x` |
|| [Gqlgen] | `1,120.44` | `97.47` | `2.56x` |
|| [Apollo GraphQL] | `907.81` | `110.54` | `2.07x` |
|| [Netflix DGS] | `810.54` | `124.15` | `1.85x` |
|| [Hasura] | `438.29` | `245.33` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `34,176.10` | `2.95` | `22.03x` |
|| [Gqlgen] | `23,813.30` | `9.33` | `15.35x` |
|| [async-graphql] | `23,762.30` | `4.22` | `15.31x` |
|| [Tailcall] | `20,667.80` | `4.86` | `13.32x` |
|| [GraphQL JIT] | `4,641.04` | `21.50` | `2.99x` |
|| [Netflix DGS] | `4,156.79` | `28.53` | `2.68x` |
|| [Apollo GraphQL] | `4,072.50` | `27.65` | `2.62x` |
|| [Hasura] | `1,551.58` | `65.31` | `1.00x` |

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
