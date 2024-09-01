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
|| [Tailcall] | `27,176.50` | `3.66` | `115.99x` |
|| [async-graphql] | `2,017.18` | `49.85` | `8.61x` |
|| [Caliban] | `1,714.88` | `58.09` | `7.32x` |
|| [GraphQL JIT] | `1,380.20` | `72.17` | `5.89x` |
|| [Gqlgen] | `759.59` | `130.64` | `3.24x` |
|| [Netflix DGS] | `365.21` | `178.48` | `1.56x` |
|| [Apollo GraphQL] | `271.19` | `362.26` | `1.16x` |
|| [Hasura] | `234.31` | `415.46` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,222.60` | `1.71` | `73.79x` |
|| [async-graphql] | `10,445.80` | `9.75` | `13.24x` |
|| [Caliban] | `9,971.97` | `10.35` | `12.64x` |
|| [Gqlgen] | `2,123.46` | `48.71` | `2.69x` |
|| [Apollo GraphQL] | `1,765.68` | `56.56` | `2.24x` |
|| [Netflix DGS] | `1,590.48` | `70.25` | `2.02x` |
|| [GraphQL JIT] | `1,431.41` | `69.76` | `1.81x` |
|| [Hasura] | `789.08` | `128.88` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,550.00` | `1.09` | `26.26x` |
|| [Tailcall] | `58,565.30` | `1.71` | `23.11x` |
|| [async-graphql] | `48,143.20` | `2.18` | `19.00x` |
|| [Gqlgen] | `46,110.60` | `5.50` | `18.20x` |
|| [Netflix DGS] | `8,196.55` | `14.90` | `3.23x` |
|| [Apollo GraphQL] | `8,004.08` | `12.70` | `3.16x` |
|| [GraphQL JIT] | `5,281.27` | `18.90` | `2.08x` |
|| [Hasura] | `2,533.90` | `39.74` | `1.00x` |

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
