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
|| [Tailcall] | `21,370.40` | `4.67` | `188.98x` |
|| [GraphQL JIT] | `1,122.63` | `88.53` | `9.93x` |
|| [async-graphql] | `990.78` | `100.22` | `8.76x` |
|| [Caliban] | `749.13` | `134.02` | `6.62x` |
|| [Gqlgen] | `355.97` | `276.46` | `3.15x` |
|| [Netflix DGS] | `188.64` | `511.86` | `1.67x` |
|| [Apollo GraphQL] | `123.91` | `729.55` | `1.10x` |
|| [Hasura] | `113.08` | `777.90` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,229.50` | `3.01` | `77.18x` |
|| [async-graphql] | `5,206.61` | `19.20` | `12.09x` |
|| [Caliban] | `4,651.63` | `22.12` | `10.80x` |
|| [GraphQL JIT] | `1,150.79` | `86.74` | `2.67x` |
|| [Gqlgen] | `1,051.49` | `104.59` | `2.44x` |
|| [Apollo GraphQL] | `855.01` | `117.28` | `1.99x` |
|| [Netflix DGS] | `813.40` | `123.58` | `1.89x` |
|| [Hasura] | `430.56` | `233.62` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,279.30` | `2.49` | `25.23x` |
|| [Caliban] | `33,199.60` | `3.03` | `20.80x` |
|| [async-graphql] | `23,368.90` | `4.33` | `14.64x` |
|| [Gqlgen] | `22,782.10` | `10.85` | `14.27x` |
|| [GraphQL JIT] | `4,658.04` | `21.41` | `2.92x` |
|| [Netflix DGS] | `4,247.32` | `28.18` | `2.66x` |
|| [Apollo GraphQL] | `3,911.96` | `28.62` | `2.45x` |
|| [Hasura] | `1,596.28` | `64.59` | `1.00x` |

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
