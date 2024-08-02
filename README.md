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
|| [Tailcall] | `28,542.50` | `3.49` | `261.61x` |
|| [async-graphql] | `1,997.79` | `49.99` | `18.31x` |
|| [Caliban] | `1,378.18` | `72.19` | `12.63x` |
|| [GraphQL JIT] | `1,295.47` | `76.90` | `11.87x` |
|| [Gqlgen] | `790.62` | `125.47` | `7.25x` |
|| [Netflix DGS] | `357.37` | `215.66` | `3.28x` |
|| [Apollo GraphQL] | `272.11` | `361.31` | `2.49x` |
|| [Hasura] | `109.10` | `368.21` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,794.20` | `1.72` | `69.02x` |
|| [async-graphql] | `9,975.29` | `10.37` | `11.91x` |
|| [Caliban] | `8,771.45` | `11.80` | `10.47x` |
|| [Gqlgen] | `2,193.64` | `47.28` | `2.62x` |
|| [Apollo GraphQL] | `1,769.93` | `56.43` | `2.11x` |
|| [Netflix DGS] | `1,565.16` | `71.05` | `1.87x` |
|| [GraphQL JIT] | `1,319.12` | `75.70` | `1.58x` |
|| [Hasura] | `837.41` | `119.20` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `65,559.90` | `1.12` | `25.24x` |
|| [Tailcall] | `59,133.10` | `1.71` | `22.77x` |
|| [async-graphql] | `48,713.00` | `2.09` | `18.75x` |
|| [Gqlgen] | `47,123.90` | `5.25` | `18.14x` |
|| [Apollo GraphQL] | `8,041.15` | `12.71` | `3.10x` |
|| [Netflix DGS] | `7,999.81` | `14.81` | `3.08x` |
|| [GraphQL JIT] | `5,164.10` | `19.33` | `1.99x` |
|| [Hasura] | `2,597.47` | `38.46` | `1.00x` |

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
