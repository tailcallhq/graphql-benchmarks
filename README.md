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
|| [Tailcall] | `27,312.80` | `3.64` | `107.29x` |
|| [async-graphql] | `1,653.05` | `60.69` | `6.49x` |
|| [Caliban] | `1,489.94` | `66.79` | `5.85x` |
|| [Hasura] | `1,265.56` | `78.67` | `4.97x` |
|| [GraphQL JIT] | `1,249.87` | `79.57` | `4.91x` |
|| [Gqlgen] | `703.01` | `140.97` | `2.76x` |
|| [Netflix DGS] | `350.15` | `220.87` | `1.38x` |
|| [Apollo GraphQL] | `254.58` | `385.14` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,957.80` | `1.69` | `46.38x` |
|| [Caliban] | `9,050.34` | `11.41` | `7.12x` |
|| [async-graphql] | `8,876.94` | `11.62` | `6.98x` |
|| [Hasura] | `2,111.67` | `47.31` | `1.66x` |
|| [Gqlgen] | `2,047.86` | `50.57` | `1.61x` |
|| [Apollo GraphQL] | `1,622.15` | `61.57` | `1.28x` |
|| [Netflix DGS] | `1,559.44` | `70.65` | `1.23x` |
|| [GraphQL JIT] | `1,271.13` | `78.54` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,578.10` | `1.11` | `30.53x` |
|| [Tailcall] | `61,771.80` | `1.63` | `27.50x` |
|| [async-graphql] | `49,289.40` | `2.08` | `21.94x` |
|| [Gqlgen] | `44,867.30` | `5.39` | `19.98x` |
|| [Netflix DGS] | `8,039.53` | `15.02` | `3.58x` |
|| [Apollo GraphQL] | `7,759.49` | `13.12` | `3.45x` |
|| [GraphQL JIT] | `4,918.23` | `20.30` | `2.19x` |
|| [Hasura] | `2,246.07` | `44.68` | `1.00x` |

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
