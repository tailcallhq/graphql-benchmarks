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
|| [Tailcall] | `29,173.60` | `3.41` | `211.81x` |
|| [async-graphql] | `2,019.59` | `49.49` | `14.66x` |
|| [Caliban] | `1,744.80` | `57.28` | `12.67x` |
|| [GraphQL JIT] | `1,342.93` | `74.16` | `9.75x` |
|| [Gqlgen] | `797.87` | `124.41` | `5.79x` |
|| [Netflix DGS] | `366.18` | `181.49` | `2.66x` |
|| [Apollo GraphQL] | `263.39` | `372.49` | `1.91x` |
|| [Hasura] | `137.74` | `587.80` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,485.30` | `1.70` | `67.37x` |
|| [Caliban] | `9,751.71` | `10.62` | `11.23x` |
|| [async-graphql] | `9,444.13` | `10.73` | `10.88x` |
|| [Gqlgen] | `2,181.26` | `47.48` | `2.51x` |
|| [Apollo GraphQL] | `1,760.69` | `56.72` | `2.03x` |
|| [Netflix DGS] | `1,598.09` | `70.06` | `1.84x` |
|| [GraphQL JIT] | `1,392.45` | `71.71` | `1.60x` |
|| [Hasura] | `868.17` | `114.99` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,512.70` | `1.07` | `26.49x` |
|| [Tailcall] | `59,015.70` | `1.71` | `23.16x` |
|| [Gqlgen] | `47,378.10` | `5.25` | `18.59x` |
|| [async-graphql] | `47,361.00` | `2.25` | `18.58x` |
|| [Netflix DGS] | `8,297.54` | `14.39` | `3.26x` |
|| [Apollo GraphQL] | `8,128.40` | `12.43` | `3.19x` |
|| [GraphQL JIT] | `5,241.04` | `19.05` | `2.06x` |
|| [Hasura] | `2,548.54` | `39.16` | `1.00x` |

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
