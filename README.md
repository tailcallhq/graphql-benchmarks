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
|| [Tailcall] | `22,000.40` | `4.54` | `183.66x` |
|| [GraphQL JIT] | `1,157.54` | `85.93` | `9.66x` |
|| [async-graphql] | `993.47` | `99.96` | `8.29x` |
|| [Caliban] | `714.85` | `141.04` | `5.97x` |
|| [Gqlgen] | `370.99` | `265.35` | `3.10x` |
|| [Netflix DGS] | `181.06` | `534.01` | `1.51x` |
|| [Apollo GraphQL] | `130.04` | `705.45` | `1.09x` |
|| [Hasura] | `119.79` | `778.41` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,973.20` | `3.03` | `78.01x` |
|| [async-graphql] | `4,945.74` | `20.25` | `11.70x` |
|| [Caliban] | `4,801.13` | `21.35` | `11.36x` |
|| [GraphQL JIT] | `1,182.68` | `84.39` | `2.80x` |
|| [Gqlgen] | `1,080.91` | `101.47` | `2.56x` |
|| [Apollo GraphQL] | `885.43` | `113.46` | `2.09x` |
|| [Netflix DGS] | `794.70` | `126.33` | `1.88x` |
|| [Hasura] | `422.68` | `238.71` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,340.80` | `2.55` | `24.38x` |
|| [Caliban] | `33,455.60` | `2.98` | `20.73x` |
|| [Gqlgen] | `24,025.90` | `10.94` | `14.89x` |
|| [async-graphql] | `22,811.00` | `4.42` | `14.14x` |
|| [GraphQL JIT] | `4,632.04` | `21.54` | `2.87x` |
|| [Netflix DGS] | `4,060.94` | `28.90` | `2.52x` |
|| [Apollo GraphQL] | `4,005.18` | `27.66` | `2.48x` |
|| [Hasura] | `1,613.54` | `64.57` | `1.00x` |

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
