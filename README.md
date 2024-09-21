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
|| [Tailcall] | `20,416.10` | `4.82` | `179.37x` |
|| [GraphQL JIT] | `1,123.93` | `88.54` | `9.87x` |
|| [async-graphql] | `1,072.96` | `92.69` | `9.43x` |
|| [Caliban] | `870.44` | `115.14` | `7.65x` |
|| [Gqlgen] | `390.53` | `252.65` | `3.43x` |
|| [Netflix DGS] | `184.50` | `534.61` | `1.62x` |
|| [Apollo GraphQL] | `133.68` | `691.19` | `1.17x` |
|| [Hasura] | `113.82` | `770.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,699.50` | `3.11` | `71.90x` |
|| [Caliban] | `5,355.98` | `18.80` | `11.78x` |
|| [async-graphql] | `5,335.23` | `18.75` | `11.73x` |
|| [GraphQL JIT] | `1,166.65` | `85.55` | `2.57x` |
|| [Gqlgen] | `1,102.65` | `99.11` | `2.42x` |
|| [Apollo GraphQL] | `893.01` | `112.41` | `1.96x` |
|| [Netflix DGS] | `797.64` | `155.58` | `1.75x` |
|| [Hasura] | `454.77` | `226.62` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,115.20` | `2.05` | `30.57x` |
|| [async-graphql] | `26,156.20` | `3.80` | `16.97x` |
|| [Tailcall] | `25,868.60` | `3.85` | `16.78x` |
|| [Gqlgen] | `25,300.60` | `5.11` | `16.41x` |
|| [GraphQL JIT] | `4,621.60` | `21.60` | `3.00x` |
|| [Apollo GraphQL] | `4,135.49` | `27.91` | `2.68x` |
|| [Netflix DGS] | `4,058.39` | `28.51` | `2.63x` |
|| [Hasura] | `1,541.32` | `64.69` | `1.00x` |

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
