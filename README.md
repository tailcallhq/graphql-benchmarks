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
|| [Tailcall] | `21,762.30` | `4.59` | `180.64x` |
|| [GraphQL JIT] | `1,134.80` | `87.67` | `9.42x` |
|| [async-graphql] | `1,011.33` | `98.10` | `8.39x` |
|| [Caliban] | `754.42` | `132.65` | `6.26x` |
|| [Gqlgen] | `403.58` | `244.42` | `3.35x` |
|| [Netflix DGS] | `184.26` | `526.15` | `1.53x` |
|| [Apollo GraphQL] | `126.60` | `718.81` | `1.05x` |
|| [Hasura] | `120.47` | `767.31` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,503.90` | `2.98` | `69.93x` |
|| [async-graphql] | `5,253.78` | `19.04` | `10.97x` |
|| [Caliban] | `4,932.89` | `20.69` | `10.30x` |
|| [GraphQL JIT] | `1,172.73` | `85.11` | `2.45x` |
|| [Gqlgen] | `1,140.84` | `95.77` | `2.38x` |
|| [Apollo GraphQL] | `888.41` | `112.92` | `1.85x` |
|| [Netflix DGS] | `796.99` | `126.62` | `1.66x` |
|| [Hasura] | `479.11` | `241.52` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,949.50` | `2.51` | `26.20x` |
|| [Caliban] | `33,302.40` | `3.00` | `21.84x` |
|| [Gqlgen] | `24,150.20` | `9.66` | `15.84x` |
|| [async-graphql] | `23,666.60` | `4.24` | `15.52x` |
|| [GraphQL JIT] | `4,664.39` | `21.40` | `3.06x` |
|| [Netflix DGS] | `4,125.47` | `28.78` | `2.71x` |
|| [Apollo GraphQL] | `4,033.47` | `27.18` | `2.64x` |
|| [Hasura] | `1,525.02` | `65.53` | `1.00x` |

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
