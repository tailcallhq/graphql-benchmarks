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
|| [Tailcall] | `28,918.00` | `3.45` | `176.15x` |
|| [async-graphql] | `1,989.60` | `50.77` | `12.12x` |
|| [Caliban] | `1,730.07` | `57.53` | `10.54x` |
|| [GraphQL JIT] | `1,345.20` | `74.04` | `8.19x` |
|| [Gqlgen] | `779.07` | `127.35` | `4.75x` |
|| [Netflix DGS] | `363.60` | `166.28` | `2.21x` |
|| [Apollo GraphQL] | `264.10` | `372.29` | `1.61x` |
|| [Hasura] | `164.17` | `484.34` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,273.70` | `1.71` | `67.90x` |
|| [async-graphql] | `9,876.63` | `10.42` | `11.51x` |
|| [Caliban] | `9,810.83` | `10.55` | `11.43x` |
|| [Gqlgen] | `2,178.79` | `47.43` | `2.54x` |
|| [Apollo GraphQL] | `1,700.14` | `58.74` | `1.98x` |
|| [Netflix DGS] | `1,591.32` | `70.92` | `1.85x` |
|| [GraphQL JIT] | `1,390.64` | `71.80` | `1.62x` |
|| [Hasura] | `858.27` | `116.40` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,704.20` | `1.06` | `26.47x` |
|| [Tailcall] | `58,587.90` | `1.72` | `22.57x` |
|| [async-graphql] | `47,843.20` | `2.27` | `18.43x` |
|| [Gqlgen] | `47,406.80` | `5.02` | `18.27x` |
|| [Netflix DGS] | `8,166.91` | `14.66` | `3.15x` |
|| [Apollo GraphQL] | `7,951.07` | `12.75` | `3.06x` |
|| [GraphQL JIT] | `5,193.47` | `19.22` | `2.00x` |
|| [Hasura] | `2,595.35` | `38.43` | `1.00x` |

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
