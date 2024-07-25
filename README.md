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
|| [Tailcall] | `29,264.70` | `3.41` | `269.75x` |
|| [async-graphql] | `1,950.03` | `52.04` | `17.97x` |
|| [Caliban] | `1,664.16` | `59.96` | `15.34x` |
|| [GraphQL JIT] | `1,312.61` | `75.86` | `12.10x` |
|| [Gqlgen] | `806.41` | `123.08` | `7.43x` |
|| [Netflix DGS] | `365.58` | `199.90` | `3.37x` |
|| [Apollo GraphQL] | `261.58` | `375.12` | `2.41x` |
|| [Hasura] | `108.49` | `597.61` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,840.90` | `1.69` | `69.52x` |
|| [Caliban] | `9,759.12` | `10.59` | `11.53x` |
|| [async-graphql] | `9,603.59` | `10.54` | `11.35x` |
|| [Gqlgen] | `2,222.96` | `46.66` | `2.63x` |
|| [Apollo GraphQL] | `1,710.74` | `58.38` | `2.02x` |
|| [Netflix DGS] | `1,604.15` | `70.00` | `1.90x` |
|| [GraphQL JIT] | `1,374.76` | `72.64` | `1.62x` |
|| [Hasura] | `846.42` | `117.90` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,357.90` | `1.04` | `26.24x` |
|| [Tailcall] | `58,932.70` | `1.71` | `22.29x` |
|| [Gqlgen] | `47,333.80` | `5.06` | `17.91x` |
|| [async-graphql] | `47,197.00` | `2.21` | `17.85x` |
|| [Netflix DGS] | `8,252.02` | `14.85` | `3.12x` |
|| [Apollo GraphQL] | `7,910.67` | `12.82` | `2.99x` |
|| [GraphQL JIT] | `5,160.87` | `19.34` | `1.95x` |
|| [Hasura] | `2,643.57` | `37.76` | `1.00x` |

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
