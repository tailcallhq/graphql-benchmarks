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
|| [Tailcall] | `28,320.00` | `3.52` | `175.34x` |
|| [async-graphql] | `1,784.61` | `57.51` | `11.05x` |
|| [Caliban] | `1,523.52` | `65.29` | `9.43x` |
|| [GraphQL JIT] | `1,311.50` | `75.93` | `8.12x` |
|| [Gqlgen] | `744.41` | `133.27` | `4.61x` |
|| [Netflix DGS] | `354.53` | `192.91` | `2.20x` |
|| [Apollo GraphQL] | `264.73` | `370.46` | `1.64x` |
|| [Hasura] | `161.51` | `496.54` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,223.00` | `1.71` | `68.82x` |
|| [Caliban] | `9,102.02` | `11.33` | `10.76x` |
|| [async-graphql] | `9,042.00` | `11.20` | `10.69x` |
|| [Gqlgen] | `2,136.74` | `48.34` | `2.53x` |
|| [Apollo GraphQL] | `1,742.58` | `57.30` | `2.06x` |
|| [Netflix DGS] | `1,584.25` | `69.49` | `1.87x` |
|| [GraphQL JIT] | `1,337.30` | `74.68` | `1.58x` |
|| [Hasura] | `845.98` | `117.95` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,940.20` | `1.09` | `26.59x` |
|| [Tailcall] | `59,316.40` | `1.70` | `23.56x` |
|| [async-graphql] | `47,630.90` | `2.14` | `18.92x` |
|| [Gqlgen] | `46,908.30` | `5.23` | `18.63x` |
|| [Netflix DGS] | `8,151.83` | `15.19` | `3.24x` |
|| [Apollo GraphQL] | `7,931.63` | `12.75` | `3.15x` |
|| [GraphQL JIT] | `5,147.67` | `19.40` | `2.04x` |
|| [Hasura] | `2,517.36` | `39.64` | `1.00x` |

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
