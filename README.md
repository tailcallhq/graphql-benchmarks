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
|| [Tailcall] | `15,376.00` | `6.50` | `128.79x` |
|| [GraphQL JIT] | `1,120.01` | `88.72` | `9.38x` |
|| [async-graphql] | `1,025.59` | `96.76` | `8.59x` |
|| [Caliban] | `742.83` | `135.30` | `6.22x` |
|| [Gqlgen] | `391.93` | `251.83` | `3.28x` |
|| [Netflix DGS] | `188.41` | `512.57` | `1.58x` |
|| [Apollo GraphQL] | `131.50` | `697.64` | `1.10x` |
|| [Hasura] | `119.39` | `773.45` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,950.30` | `4.55` | `48.44x` |
|| [async-graphql] | `5,285.20` | `18.91` | `11.66x` |
|| [Caliban] | `4,776.96` | `21.46` | `10.54x` |
|| [GraphQL JIT] | `1,164.38` | `85.71` | `2.57x` |
|| [Gqlgen] | `1,123.32` | `96.93` | `2.48x` |
|| [Apollo GraphQL] | `887.99` | `113.06` | `1.96x` |
|| [Netflix DGS] | `811.86` | `123.91` | `1.79x` |
|| [Hasura] | `453.12` | `223.39` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,405.80` | `3.00` | `21.63x` |
|| [Gqlgen] | `24,614.70` | `10.01` | `15.94x` |
|| [async-graphql] | `24,087.00` | `4.16` | `15.59x` |
|| [Tailcall] | `21,170.20` | `4.74` | `13.71x` |
|| [GraphQL JIT] | `4,672.79` | `21.35` | `3.03x` |
|| [Netflix DGS] | `4,158.62` | `27.88` | `2.69x` |
|| [Apollo GraphQL] | `4,001.99` | `27.01` | `2.59x` |
|| [Hasura] | `1,544.56` | `65.05` | `1.00x` |

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
