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
|| [Tailcall] | `21,268.60` | `4.69` | `281.68x` |
|| [GraphQL JIT] | `1,137.14` | `87.43` | `15.06x` |
|| [async-graphql] | `954.61` | `104.07` | `12.64x` |
|| [Caliban] | `759.61` | `131.65` | `10.06x` |
|| [Gqlgen] | `388.20` | `254.14` | `5.14x` |
|| [Netflix DGS] | `185.49` | `524.88` | `2.46x` |
|| [Apollo GraphQL] | `127.18` | `717.15` | `1.68x` |
|| [Hasura] | `75.51` | `651.78` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,521.40` | `3.07` | `71.97x` |
|| [Caliban] | `4,843.99` | `21.13` | `10.72x` |
|| [async-graphql] | `4,811.63` | `20.79` | `10.65x` |
|| [GraphQL JIT] | `1,174.07` | `85.01` | `2.60x` |
|| [Gqlgen] | `1,120.86` | `97.47` | `2.48x` |
|| [Apollo GraphQL] | `874.52` | `114.82` | `1.94x` |
|| [Netflix DGS] | `811.38` | `123.94` | `1.80x` |
|| [Hasura] | `451.90` | `226.87` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,622.90` | `2.58` | `26.11x` |
|| [Caliban] | `34,077.10` | `2.95` | `23.04x` |
|| [Gqlgen] | `24,241.50` | `9.21` | `16.39x` |
|| [async-graphql] | `23,156.70` | `4.34` | `15.66x` |
|| [GraphQL JIT] | `4,681.63` | `21.32` | `3.17x` |
|| [Netflix DGS] | `4,219.02` | `28.09` | `2.85x` |
|| [Apollo GraphQL] | `4,017.93` | `28.17` | `2.72x` |
|| [Hasura] | `1,478.99` | `70.27` | `1.00x` |

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
