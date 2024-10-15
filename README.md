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
|| [Tailcall] | `8,367.29` | `11.92` | `71.67x` |
|| [GraphQL JIT] | `1,025.33` | `96.88` | `8.78x` |
|| [async-graphql] | `1,000.79` | `99.19` | `8.57x` |
|| [Caliban] | `683.86` | `148.36` | `5.86x` |
|| [Gqlgen] | `356.54` | `275.97` | `3.05x` |
|| [Netflix DGS] | `191.44` | `504.69` | `1.64x` |
|| [Apollo GraphQL] | `134.83` | `685.26` | `1.15x` |
|| [Hasura] | `116.75` | `797.65` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,339.30` | `6.52` | `34.56x` |
|| [async-graphql] | `5,235.53` | `19.13` | `11.80x` |
|| [Caliban] | `4,779.76` | `21.33` | `10.77x` |
|| [GraphQL JIT] | `1,097.29` | `90.93` | `2.47x` |
|| [Gqlgen] | `1,056.77` | `103.62` | `2.38x` |
|| [Apollo GraphQL] | `911.85` | `110.10` | `2.05x` |
|| [Netflix DGS] | `812.55` | `123.64` | `1.83x` |
|| [Hasura] | `443.85` | `230.95` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,482.20` | `3.01` | `23.19x` |
|| [async-graphql] | `23,487.70` | `4.27` | `16.27x` |
|| [Gqlgen] | `22,950.20` | `9.93` | `15.89x` |
|| [Tailcall] | `20,571.40` | `4.88` | `14.25x` |
|| [GraphQL JIT] | `4,521.79` | `22.06` | `3.13x` |
|| [Netflix DGS] | `4,219.96` | `28.34` | `2.92x` |
|| [Apollo GraphQL] | `4,042.64` | `26.95` | `2.80x` |
|| [Hasura] | `1,444.00` | `70.90` | `1.00x` |

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
