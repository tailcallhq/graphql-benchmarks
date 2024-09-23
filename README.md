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
|| [Tailcall] | `19,754.60` | `4.99` | `176.85x` |
|| [GraphQL JIT] | `1,131.70` | `87.90` | `10.13x` |
|| [async-graphql] | `1,084.20` | `91.70` | `9.71x` |
|| [Caliban] | `846.96` | `118.64` | `7.58x` |
|| [Gqlgen] | `399.75` | `246.83` | `3.58x` |
|| [Netflix DGS] | `186.87` | `522.69` | `1.67x` |
|| [Apollo GraphQL] | `131.98` | `695.61` | `1.18x` |
|| [Hasura] | `111.70` | `746.23` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,966.70` | `3.07` | `69.43x` |
|| [Caliban] | `5,400.99` | `18.64` | `11.73x` |
|| [async-graphql] | `5,368.00` | `18.62` | `11.66x` |
|| [GraphQL JIT] | `1,150.69` | `86.66` | `2.50x` |
|| [Gqlgen] | `1,123.29` | `97.97` | `2.44x` |
|| [Apollo GraphQL] | `880.65` | `114.19` | `1.91x` |
|| [Netflix DGS] | `811.29` | `157.99` | `1.76x` |
|| [Hasura] | `460.40` | `216.40` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,478.60` | `2.07` | `29.47x` |
|| [Gqlgen] | `25,667.50` | `5.00` | `16.28x` |
|| [async-graphql] | `25,659.20` | `3.89` | `16.27x` |
|| [Tailcall] | `25,320.30` | `3.93` | `16.06x` |
|| [GraphQL JIT] | `4,578.47` | `21.80` | `2.90x` |
|| [Netflix DGS] | `4,202.38` | `27.51` | `2.66x` |
|| [Apollo GraphQL] | `3,996.76` | `28.61` | `2.53x` |
|| [Hasura] | `1,576.99` | `63.44` | `1.00x` |

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
