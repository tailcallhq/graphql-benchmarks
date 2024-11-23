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
|| [Tailcall] | `19,941.20` | `5.01` | `164.53x` |
|| [GraphQL JIT] | `1,128.13` | `88.17` | `9.31x` |
|| [async-graphql] | `983.70` | `100.82` | `8.12x` |
|| [Caliban] | `728.18` | `138.06` | `6.01x` |
|| [Gqlgen] | `381.05` | `258.78` | `3.14x` |
|| [Netflix DGS] | `181.74` | `530.52` | `1.50x` |
|| [Apollo GraphQL] | `133.73` | `689.95` | `1.10x` |
|| [Hasura] | `121.20` | `768.39` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,105.70` | `3.02` | `75.17x` |
|| [async-graphql] | `5,108.42` | `19.70` | `11.60x` |
|| [Caliban] | `4,758.56` | `21.47` | `10.80x` |
|| [GraphQL JIT] | `1,172.21` | `85.15` | `2.66x` |
|| [Gqlgen] | `1,083.92` | `101.30` | `2.46x` |
|| [Apollo GraphQL] | `904.13` | `111.05` | `2.05x` |
|| [Netflix DGS] | `799.51` | `126.06` | `1.82x` |
|| [Hasura] | `440.42` | `248.74` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,142.90` | `2.49` | `26.49x` |
|| [Caliban] | `32,579.60` | `3.09` | `21.50x` |
|| [Gqlgen] | `24,519.00` | `8.90` | `16.18x` |
|| [async-graphql] | `24,272.20` | `4.13` | `16.01x` |
|| [GraphQL JIT] | `4,605.65` | `21.67` | `3.04x` |
|| [Netflix DGS] | `4,123.70` | `28.23` | `2.72x` |
|| [Apollo GraphQL] | `4,121.24` | `27.51` | `2.72x` |
|| [Hasura] | `1,515.60` | `67.67` | `1.00x` |

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
