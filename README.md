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
|| [Tailcall] | `29,648.30` | `3.36` | `128.53x` |
|| [async-graphql] | `2,008.12` | `50.05` | `8.71x` |
|| [Caliban] | `1,786.62` | `55.82` | `7.75x` |
|| [GraphQL JIT] | `1,334.29` | `74.62` | `5.78x` |
|| [Gqlgen] | `805.65` | `123.22` | `3.49x` |
|| [Netflix DGS] | `370.27` | `171.57` | `1.61x` |
|| [Apollo GraphQL] | `264.89` | `370.76` | `1.15x` |
|| [Hasura] | `230.68` | `441.79` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,894.20` | `1.69` | `76.59x` |
|| [async-graphql] | `10,320.70` | `9.78` | `13.42x` |
|| [Caliban] | `9,917.08` | `10.40` | `12.90x` |
|| [Gqlgen] | `2,209.35` | `46.81` | `2.87x` |
|| [Apollo GraphQL] | `1,768.58` | `56.48` | `2.30x` |
|| [Netflix DGS] | `1,582.76` | `70.33` | `2.06x` |
|| [GraphQL JIT] | `1,382.52` | `72.23` | `1.80x` |
|| [Hasura] | `768.96` | `129.96` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,434.90` | `1.07` | `27.53x` |
|| [Tailcall] | `59,504.30` | `1.69` | `24.30x` |
|| [async-graphql] | `49,604.70` | `2.09` | `20.25x` |
|| [Gqlgen] | `48,074.90` | `5.06` | `19.63x` |
|| [Netflix DGS] | `8,000.09` | `14.76` | `3.27x` |
|| [Apollo GraphQL] | `7,979.36` | `12.81` | `3.26x` |
|| [GraphQL JIT] | `5,134.89` | `19.44` | `2.10x` |
|| [Hasura] | `2,449.08` | `40.93` | `1.00x` |

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
