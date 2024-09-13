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
|| [Tailcall] | `18,227.90` | `5.47` | `152.86x` |
|| [GraphQL JIT] | `1,108.44` | `89.76` | `9.30x` |
|| [async-graphql] | `907.58` | `109.41` | `7.61x` |
|| [Caliban] | `717.36` | `140.31` | `6.02x` |
|| [Gqlgen] | `380.63` | `258.84` | `3.19x` |
|| [Netflix DGS] | `193.64` | `497.69` | `1.62x` |
|| [Apollo GraphQL] | `132.59` | `694.12` | `1.11x` |
|| [Hasura] | `119.25` | `725.90` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,561.90` | `3.27` | `66.32x` |
|| [async-graphql] | `5,038.98` | `20.13` | `10.94x` |
|| [Caliban] | `4,851.17` | `21.00` | `10.53x` |
|| [GraphQL JIT] | `1,146.63` | `87.03` | `2.49x` |
|| [Gqlgen] | `1,104.47` | `99.20` | `2.40x` |
|| [Apollo GraphQL] | `901.58` | `111.34` | `1.96x` |
|| [Netflix DGS] | `813.59` | `123.98` | `1.77x` |
|| [Hasura] | `460.81` | `225.51` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,052.10` | `2.61` | `25.55x` |
|| [Tailcall] | `24,247.40` | `4.13` | `16.28x` |
|| [Gqlgen] | `24,038.80` | `9.97` | `16.14x` |
|| [async-graphql] | `23,564.50` | `4.27` | `15.82x` |
|| [GraphQL JIT] | `4,543.70` | `21.95` | `3.05x` |
|| [Netflix DGS] | `4,250.27` | `28.31` | `2.85x` |
|| [Apollo GraphQL] | `4,077.69` | `27.28` | `2.74x` |
|| [Hasura] | `1,489.13` | `67.56` | `1.00x` |

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
