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
|| [Tailcall] | `30,281.00` | `3.29` | `113.53x` |
|| [async-graphql] | `1,866.94` | `54.13` | `7.00x` |
|| [Caliban] | `1,556.85` | `63.86` | `5.84x` |
|| [Hasura] | `1,521.99` | `65.65` | `5.71x` |
|| [GraphQL JIT] | `1,351.23` | `73.67` | `5.07x` |
|| [Gqlgen] | `779.06` | `127.43` | `2.92x` |
|| [Netflix DGS] | `361.91` | `169.33` | `1.36x` |
|| [Apollo GraphQL] | `266.73` | `367.90` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,039.70` | `1.61` | `44.51x` |
|| [async-graphql] | `9,514.46` | `10.61` | `6.83x` |
|| [Caliban] | `9,239.61` | `11.17` | `6.63x` |
|| [Hasura] | `2,497.09` | `40.02` | `1.79x` |
|| [Gqlgen] | `2,190.07` | `47.39` | `1.57x` |
|| [Apollo GraphQL] | `1,714.06` | `58.25` | `1.23x` |
|| [Netflix DGS] | `1,603.24` | `69.58` | `1.15x` |
|| [GraphQL JIT] | `1,393.75` | `71.64` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,835.00` | `1.07` | `26.81x` |
|| [Tailcall] | `63,809.50` | `1.58` | `25.22x` |
|| [async-graphql] | `50,635.20` | `2.04` | `20.01x` |
|| [Gqlgen] | `47,541.90` | `5.21` | `18.79x` |
|| [Netflix DGS] | `8,138.67` | `15.05` | `3.22x` |
|| [Apollo GraphQL] | `7,825.48` | `12.94` | `3.09x` |
|| [GraphQL JIT] | `5,162.86` | `19.34` | `2.04x` |
|| [Hasura] | `2,530.12` | `39.42` | `1.00x` |

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
