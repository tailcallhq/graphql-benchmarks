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
|| [Tailcall] | `29,985.40` | `3.32` | `127.22x` |
|| [async-graphql] | `2,035.25` | `49.21` | `8.64x` |
|| [Caliban] | `1,767.34` | `56.36` | `7.50x` |
|| [GraphQL JIT] | `1,361.81` | `73.13` | `5.78x` |
|| [Gqlgen] | `776.54` | `127.77` | `3.29x` |
|| [Netflix DGS] | `361.60` | `155.12` | `1.53x` |
|| [Apollo GraphQL] | `274.02` | `358.14` | `1.16x` |
|| [Hasura] | `235.70` | `434.99` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,341.20` | `1.68` | `75.64x` |
|| [async-graphql] | `10,279.30` | `9.97` | `13.10x` |
|| [Caliban] | `10,011.50` | `10.31` | `12.76x` |
|| [Gqlgen] | `2,197.21` | `47.13` | `2.80x` |
|| [Apollo GraphQL] | `1,797.20` | `55.55` | `2.29x` |
|| [Netflix DGS] | `1,578.20` | `70.90` | `2.01x` |
|| [GraphQL JIT] | `1,389.22` | `71.87` | `1.77x` |
|| [Hasura] | `784.48` | `127.17` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,802.40` | `1.06` | `27.22x` |
|| [Tailcall] | `59,788.80` | `1.68` | `24.00x` |
|| [Gqlgen] | `47,857.00` | `5.10` | `19.21x` |
|| [async-graphql] | `47,617.70` | `2.18` | `19.12x` |
|| [Apollo GraphQL] | `8,192.60` | `12.38` | `3.29x` |
|| [Netflix DGS] | `8,095.21` | `15.03` | `3.25x` |
|| [GraphQL JIT] | `5,208.43` | `19.17` | `2.09x` |
|| [Hasura] | `2,491.07` | `40.05` | `1.00x` |

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
