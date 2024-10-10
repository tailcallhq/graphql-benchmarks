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
|| [Tailcall] | `13,642.20` | `7.29` | `119.56x` |
|| [GraphQL JIT] | `1,107.98` | `89.68` | `9.71x` |
|| [async-graphql] | `1,050.67` | `94.53` | `9.21x` |
|| [Caliban] | `786.14` | `128.36` | `6.89x` |
|| [Gqlgen] | `365.45` | `269.63` | `3.20x` |
|| [Netflix DGS] | `189.06` | `517.88` | `1.66x` |
|| [Apollo GraphQL] | `120.78` | `746.86` | `1.06x` |
|| [Hasura] | `114.10` | `788.60` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,532.90` | `4.62` | `47.71x` |
|| [Caliban] | `5,416.37` | `18.54` | `12.00x` |
|| [async-graphql] | `5,155.19` | `19.39` | `11.42x` |
|| [GraphQL JIT] | `1,150.36` | `86.75` | `2.55x` |
|| [Gqlgen] | `1,071.03` | `103.37` | `2.37x` |
|| [Apollo GraphQL] | `852.00` | `117.92` | `1.89x` |
|| [Netflix DGS] | `807.63` | `158.45` | `1.79x` |
|| [Hasura] | `451.33` | `227.32` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,070.20` | `2.06` | `28.14x` |
|| [async-graphql] | `25,156.40` | `3.96` | `15.04x` |
|| [Gqlgen] | `24,651.20` | `5.24` | `14.74x` |
|| [Tailcall] | `21,172.60` | `4.74` | `12.66x` |
|| [GraphQL JIT] | `4,544.02` | `21.96` | `2.72x` |
|| [Netflix DGS] | `4,152.81` | `28.19` | `2.48x` |
|| [Apollo GraphQL] | `3,925.68` | `29.57` | `2.35x` |
|| [Hasura] | `1,672.55` | `64.65` | `1.00x` |

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
