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
|| [Tailcall] | `13,654.10` | `7.29` | `122.78x` |
|| [GraphQL JIT] | `1,095.44` | `90.84` | `9.85x` |
|| [async-graphql] | `1,001.77` | `99.21` | `9.01x` |
|| [Caliban] | `926.49` | `108.10` | `8.33x` |
|| [Gqlgen] | `399.76` | `246.79` | `3.59x` |
|| [Netflix DGS] | `187.46` | `529.02` | `1.69x` |
|| [Apollo GraphQL] | `130.83` | `704.04` | `1.18x` |
|| [Hasura] | `111.21` | `769.63` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,605.10` | `4.60` | `47.92x` |
|| [Caliban] | `5,786.73` | `17.33` | `12.83x` |
|| [async-graphql] | `5,106.90` | `19.59` | `11.33x` |
|| [GraphQL JIT] | `1,160.54` | `85.98` | `2.57x` |
|| [Gqlgen] | `1,116.38` | `98.15` | `2.48x` |
|| [Apollo GraphQL] | `885.08` | `113.53` | `1.96x` |
|| [Netflix DGS] | `810.11` | `152.51` | `1.80x` |
|| [Hasura] | `450.88` | `232.73` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,564.40` | `1.99` | `32.85x` |
|| [Gqlgen] | `25,757.60` | `4.86` | `17.42x` |
|| [async-graphql] | `24,689.70` | `4.04` | `16.70x` |
|| [Tailcall] | `21,153.80` | `4.74` | `14.31x` |
|| [GraphQL JIT] | `4,510.63` | `22.13` | `3.05x` |
|| [Netflix DGS] | `4,150.80` | `27.26` | `2.81x` |
|| [Apollo GraphQL] | `3,975.49` | `29.43` | `2.69x` |
|| [Hasura] | `1,478.33` | `67.36` | `1.00x` |

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
