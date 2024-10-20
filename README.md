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
|| [Tailcall] | `9,476.13` | `10.53` | `88.10x` |
|| [GraphQL JIT] | `1,135.59` | `87.52` | `10.56x` |
|| [async-graphql] | `994.96` | `99.79` | `9.25x` |
|| [Caliban] | `783.90` | `128.53` | `7.29x` |
|| [Gqlgen] | `366.35` | `269.05` | `3.41x` |
|| [Netflix DGS] | `190.02` | `508.77` | `1.77x` |
|| [Apollo GraphQL] | `131.82` | `696.15` | `1.23x` |
|| [Hasura] | `107.56` | `790.83` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `18,857.30` | `5.30` | `44.84x` |
|| [async-graphql] | `5,064.97` | `19.82` | `12.05x` |
|| [Caliban] | `4,880.50` | `20.94` | `11.61x` |
|| [GraphQL JIT] | `1,170.02` | `85.32` | `2.78x` |
|| [Gqlgen] | `1,080.97` | `101.42` | `2.57x` |
|| [Apollo GraphQL] | `908.87` | `110.39` | `2.16x` |
|| [Netflix DGS] | `816.72` | `123.14` | `1.94x` |
|| [Hasura] | `420.50` | `241.84` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,417.40` | `3.00` | `22.45x` |
|| [Tailcall] | `25,064.60` | `4.03` | `16.84x` |
|| [async-graphql] | `23,599.10` | `4.28` | `15.85x` |
|| [Gqlgen] | `23,384.60` | `9.73` | `15.71x` |
|| [GraphQL JIT] | `4,573.02` | `21.81` | `3.07x` |
|| [Netflix DGS] | `4,228.55` | `28.27` | `2.84x` |
|| [Apollo GraphQL] | `4,068.75` | `27.85` | `2.73x` |
|| [Hasura] | `1,488.66` | `67.12` | `1.00x` |

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
