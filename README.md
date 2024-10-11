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
|| [Tailcall] | `12,671.80` | `7.88` | `104.67x` |
|| [GraphQL JIT] | `1,158.54` | `85.88` | `9.57x` |
|| [async-graphql] | `944.30` | `105.34` | `7.80x` |
|| [Caliban] | `759.63` | `131.02` | `6.27x` |
|| [Gqlgen] | `395.61` | `249.31` | `3.27x` |
|| [Netflix DGS] | `189.96` | `504.15` | `1.57x` |
|| [Apollo GraphQL] | `129.56` | `704.77` | `1.07x` |
|| [Hasura] | `121.06` | `740.49` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `20,885.60` | `4.79` | `46.76x` |
|| [async-graphql] | `5,176.76` | `19.35` | `11.59x` |
|| [Caliban] | `4,800.90` | `21.32` | `10.75x` |
|| [GraphQL JIT] | `1,194.56` | `83.55` | `2.67x` |
|| [Gqlgen] | `1,107.04` | `99.04` | `2.48x` |
|| [Apollo GraphQL] | `873.72` | `114.93` | `1.96x` |
|| [Netflix DGS] | `804.38` | `124.83` | `1.80x` |
|| [Hasura] | `446.64` | `229.53` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,330.20` | `3.01` | `21.41x` |
|| [Gqlgen] | `23,623.40` | `9.73` | `15.17x` |
|| [async-graphql] | `23,442.70` | `4.27` | `15.06x` |
|| [Tailcall] | `20,678.70` | `4.85` | `13.28x` |
|| [GraphQL JIT] | `4,659.25` | `21.40` | `2.99x` |
|| [Netflix DGS] | `4,203.54` | `28.35` | `2.70x` |
|| [Apollo GraphQL] | `4,006.81` | `27.54` | `2.57x` |
|| [Hasura] | `1,557.06` | `65.91` | `1.00x` |

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
