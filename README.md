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
|| [Tailcall] | `21,513.80` | `4.64` | `179.89x` |
|| [GraphQL JIT] | `1,116.56` | `89.01` | `9.34x` |
|| [async-graphql] | `990.55` | `100.20` | `8.28x` |
|| [Caliban] | `783.68` | `127.99` | `6.55x` |
|| [Gqlgen] | `397.51` | `247.96` | `3.32x` |
|| [Netflix DGS] | `183.54` | `527.11` | `1.53x` |
|| [Apollo GraphQL] | `127.15` | `719.58` | `1.06x` |
|| [Hasura] | `119.60` | `783.19` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,813.80` | `3.05` | `77.38x` |
|| [async-graphql] | `5,214.62` | `19.24` | `12.30x` |
|| [Caliban] | `4,620.87` | `22.16` | `10.90x` |
|| [GraphQL JIT] | `1,159.36` | `86.09` | `2.73x` |
|| [Gqlgen] | `1,111.36` | `98.68` | `2.62x` |
|| [Apollo GraphQL] | `858.72` | `116.84` | `2.02x` |
|| [Netflix DGS] | `796.94` | `125.95` | `1.88x` |
|| [Hasura] | `424.08` | `244.29` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,139.90` | `2.57` | `25.82x` |
|| [Caliban] | `32,742.60` | `3.07` | `21.60x` |
|| [Gqlgen] | `24,637.10` | `7.80` | `16.25x` |
|| [async-graphql] | `23,737.20` | `4.26` | `15.66x` |
|| [GraphQL JIT] | `4,628.80` | `21.56` | `3.05x` |
|| [Netflix DGS] | `4,154.01` | `28.02` | `2.74x` |
|| [Apollo GraphQL] | `3,926.37` | `27.98` | `2.59x` |
|| [Hasura] | `1,515.83` | `66.66` | `1.00x` |

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
