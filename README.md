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
|| [Tailcall] | `22,805.00` | `4.30` | `214.34x` |
|| [async-graphql] | `1,080.88` | `91.86` | `10.16x` |
|| [GraphQL JIT] | `1,038.83` | `95.78` | `9.76x` |
|| [Caliban] | `902.18` | `110.94` | `8.48x` |
|| [Gqlgen] | `400.68` | `246.33` | `3.77x` |
|| [Netflix DGS] | `191.44` | `506.58` | `1.80x` |
|| [Apollo GraphQL] | `133.94` | `687.14` | `1.26x` |
|| [Hasura] | `106.40` | `824.18` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `36,300.30` | `2.69` | `82.05x` |
|| [Caliban] | `5,554.80` | `18.07` | `12.55x` |
|| [async-graphql] | `5,296.11` | `18.90` | `11.97x` |
|| [Gqlgen] | `1,112.44` | `98.53` | `2.51x` |
|| [GraphQL JIT] | `1,066.55` | `93.57` | `2.41x` |
|| [Apollo GraphQL] | `896.38` | `112.08` | `2.03x` |
|| [Netflix DGS] | `818.73` | `149.69` | `1.85x` |
|| [Hasura] | `442.44` | `226.86` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,657.70` | `2.04` | `30.11x` |
|| [Tailcall] | `46,811.10` | `2.09` | `29.57x` |
|| [Gqlgen] | `25,725.90` | `4.91` | `16.25x` |
|| [async-graphql] | `25,616.50` | `3.92` | `16.18x` |
|| [GraphQL JIT] | `4,434.19` | `22.51` | `2.80x` |
|| [Netflix DGS] | `4,119.79` | `27.30` | `2.60x` |
|| [Apollo GraphQL] | `4,071.10` | `27.92` | `2.57x` |
|| [Hasura] | `1,583.00` | `64.75` | `1.00x` |

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
