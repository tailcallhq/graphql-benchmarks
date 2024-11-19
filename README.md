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
|| [Tailcall] | `21,444.80` | `4.66` | `179.93x` |
|| [GraphQL JIT] | `1,099.33` | `90.43` | `9.22x` |
|| [async-graphql] | `989.36` | `100.31` | `8.30x` |
|| [Caliban] | `736.27` | `135.86` | `6.18x` |
|| [Gqlgen] | `393.84` | `250.39` | `3.30x` |
|| [Netflix DGS] | `182.71` | `531.12` | `1.53x` |
|| [Apollo GraphQL] | `123.42` | `735.02` | `1.04x` |
|| [Hasura] | `119.19` | `748.17` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,915.30` | `3.03` | `73.62x` |
|| [async-graphql] | `5,106.64` | `19.58` | `11.42x` |
|| [Caliban] | `4,836.83` | `21.18` | `10.82x` |
|| [Gqlgen] | `1,115.71` | `98.62` | `2.50x` |
|| [GraphQL JIT] | `1,110.66` | `89.84` | `2.48x` |
|| [Apollo GraphQL] | `850.06` | `118.17` | `1.90x` |
|| [Netflix DGS] | `797.19` | `125.99` | `1.78x` |
|| [Hasura] | `447.08` | `233.77` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,113.80` | `2.57` | `26.53x` |
|| [Caliban] | `32,996.60` | `3.05` | `22.38x` |
|| [Gqlgen] | `24,479.60` | `8.38` | `16.61x` |
|| [async-graphql] | `23,457.60` | `4.29` | `15.91x` |
|| [GraphQL JIT] | `4,448.93` | `22.42` | `3.02x` |
|| [Netflix DGS] | `4,126.52` | `28.51` | `2.80x` |
|| [Apollo GraphQL] | `3,971.73` | `28.08` | `2.69x` |
|| [Hasura] | `1,474.20` | `68.95` | `1.00x` |

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
