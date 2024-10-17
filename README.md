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
|| [Tailcall] | `8,518.86` | `11.72` | `72.95x` |
|| [GraphQL JIT] | `1,131.62` | `87.88` | `9.69x` |
|| [async-graphql] | `987.87` | `101.11` | `8.46x` |
|| [Caliban] | `783.24` | `127.96` | `6.71x` |
|| [Gqlgen] | `397.09` | `248.36` | `3.40x` |
|| [Netflix DGS] | `186.69` | `516.39` | `1.60x` |
|| [Apollo GraphQL] | `133.00` | `689.55` | `1.14x` |
|| [Hasura] | `116.78` | `739.53` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,313.40` | `6.12` | `35.27x` |
|| [async-graphql] | `5,155.35` | `19.46` | `11.15x` |
|| [Caliban] | `4,811.18` | `21.32` | `10.40x` |
|| [Gqlgen] | `1,140.10` | `95.66` | `2.46x` |
|| [GraphQL JIT] | `1,127.52` | `88.50` | `2.44x` |
|| [Apollo GraphQL] | `923.97` | `108.66` | `2.00x` |
|| [Netflix DGS] | `802.07` | `125.11` | `1.73x` |
|| [Hasura] | `462.57` | `245.16` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,175.30` | `3.01` | `20.97x` |
|| [Gqlgen] | `24,797.10` | `9.06` | `15.67x` |
|| [async-graphql] | `23,463.80` | `4.26` | `14.83x` |
|| [Tailcall] | `21,229.10` | `4.73` | `13.42x` |
|| [GraphQL JIT] | `4,530.15` | `22.03` | `2.86x` |
|| [Netflix DGS] | `4,192.37` | `28.10` | `2.65x` |
|| [Apollo GraphQL] | `4,146.43` | `26.11` | `2.62x` |
|| [Hasura] | `1,582.16` | `66.11` | `1.00x` |

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
