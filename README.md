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
|| [Tailcall] | `28,438.00` | `3.50` | `123.77x` |
|| [async-graphql] | `2,054.97` | `48.64` | `8.94x` |
|| [Caliban] | `1,782.35` | `55.91` | `7.76x` |
|| [GraphQL JIT] | `1,369.01` | `72.74` | `5.96x` |
|| [Gqlgen] | `684.62` | `144.80` | `2.98x` |
|| [Netflix DGS] | `362.16` | `174.05` | `1.58x` |
|| [Apollo GraphQL] | `274.98` | `356.92` | `1.20x` |
|| [Hasura] | `229.76` | `425.77` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,537.50` | `1.67` | `81.31x` |
|| [async-graphql] | `10,397.60` | `9.89` | `14.20x` |
|| [Caliban] | `9,980.49` | `10.34` | `13.63x` |
|| [Gqlgen] | `2,004.64` | `51.68` | `2.74x` |
|| [Apollo GraphQL] | `1,791.19` | `55.76` | `2.45x` |
|| [Netflix DGS] | `1,593.66` | `71.04` | `2.18x` |
|| [GraphQL JIT] | `1,422.76` | `70.18` | `1.94x` |
|| [Hasura] | `732.25` | `136.74` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,477.90` | `1.09` | `27.95x` |
|| [Tailcall] | `59,150.00` | `1.70` | `24.50x` |
|| [async-graphql] | `47,746.50` | `2.18` | `19.78x` |
|| [Gqlgen] | `44,946.70` | `5.46` | `18.62x` |
|| [Apollo GraphQL] | `8,220.26` | `12.34` | `3.40x` |
|| [Netflix DGS] | `8,200.16` | `14.86` | `3.40x` |
|| [GraphQL JIT] | `5,294.31` | `18.86` | `2.19x` |
|| [Hasura] | `2,414.45` | `41.43` | `1.00x` |

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
