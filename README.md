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
|| [Tailcall] | `8,174.54` | `12.21` | `67.77x` |
|| [GraphQL JIT] | `1,125.42` | `88.35` | `9.33x` |
|| [async-graphql] | `938.66` | `105.79` | `7.78x` |
|| [Caliban] | `765.12` | `131.12` | `6.34x` |
|| [Gqlgen] | `397.80` | `247.88` | `3.30x` |
|| [Netflix DGS] | `190.00` | `510.62` | `1.58x` |
|| [Apollo GraphQL] | `129.05` | `708.97` | `1.07x` |
|| [Hasura] | `120.61` | `757.18` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,529.60` | `6.44` | `33.20x` |
|| [async-graphql] | `4,873.65` | `20.51` | `10.42x` |
|| [Caliban] | `4,846.00` | `21.10` | `10.36x` |
|| [GraphQL JIT] | `1,163.33` | `85.75` | `2.49x` |
|| [Gqlgen] | `1,124.96` | `97.34` | `2.40x` |
|| [Apollo GraphQL] | `868.86` | `115.52` | `1.86x` |
|| [Netflix DGS] | `813.08` | `123.20` | `1.74x` |
|| [Hasura] | `467.83` | `219.61` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,108.60` | `3.03` | `21.11x` |
|| [Gqlgen] | `24,395.60` | `9.88` | `15.56x` |
|| [async-graphql] | `23,193.90` | `4.31` | `14.79x` |
|| [Tailcall] | `20,582.80` | `4.88` | `13.13x` |
|| [GraphQL JIT] | `4,597.90` | `21.68` | `2.93x` |
|| [Netflix DGS] | `4,233.52` | `27.76` | `2.70x` |
|| [Apollo GraphQL] | `4,012.28` | `28.00` | `2.56x` |
|| [Hasura] | `1,568.16` | `64.83` | `1.00x` |

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
