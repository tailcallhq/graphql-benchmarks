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
|| [Tailcall] | `27,113.80` | `3.66` | `125.68x` |
|| [async-graphql] | `2,047.65` | `48.75` | `9.49x` |
|| [Caliban] | `1,756.84` | `56.65` | `8.14x` |
|| [GraphQL JIT] | `1,365.14` | `72.97` | `6.33x` |
|| [Gqlgen] | `798.72` | `124.32` | `3.70x` |
|| [Netflix DGS] | `363.10` | `200.33` | `1.68x` |
|| [Apollo GraphQL] | `265.81` | `369.46` | `1.23x` |
|| [Hasura] | `215.73` | `456.53` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,719.50` | `1.72` | `76.01x` |
|| [async-graphql] | `10,366.30` | `9.68` | `13.65x` |
|| [Caliban] | `9,798.88` | `10.55` | `12.90x` |
|| [Gqlgen] | `2,208.08` | `47.03` | `2.91x` |
|| [Apollo GraphQL] | `1,721.31` | `58.00` | `2.27x` |
|| [Netflix DGS] | `1,598.35` | `70.19` | `2.10x` |
|| [GraphQL JIT] | `1,396.29` | `71.50` | `1.84x` |
|| [Hasura] | `759.37` | `135.08` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `63,046.70` | `1.34` | `25.48x` |
|| [Tailcall] | `58,079.20` | `1.73` | `23.47x` |
|| [async-graphql] | `48,013.80` | `2.17` | `19.40x` |
|| [Gqlgen] | `47,467.70` | `5.07` | `19.18x` |
|| [Netflix DGS] | `8,304.67` | `14.95` | `3.36x` |
|| [Apollo GraphQL] | `7,947.79` | `12.79` | `3.21x` |
|| [GraphQL JIT] | `5,189.66` | `19.24` | `2.10x` |
|| [Hasura] | `2,474.39` | `40.64` | `1.00x` |

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
