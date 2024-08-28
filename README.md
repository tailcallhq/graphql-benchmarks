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
|| [Tailcall] | `30,139.00` | `3.31` | `135.52x` |
|| [async-graphql] | `2,042.97` | `49.26` | `9.19x` |
|| [Caliban] | `1,771.81` | `56.89` | `7.97x` |
|| [GraphQL JIT] | `1,351.00` | `73.65` | `6.07x` |
|| [Gqlgen] | `787.95` | `125.93` | `3.54x` |
|| [Netflix DGS] | `368.17` | `169.74` | `1.66x` |
|| [Apollo GraphQL] | `258.99` | `378.65` | `1.16x` |
|| [Hasura] | `222.40` | `448.35` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,464.00` | `1.68` | `81.49x` |
|| [async-graphql] | `10,460.30` | `9.80` | `14.34x` |
|| [Caliban] | `10,266.30` | `10.04` | `14.07x` |
|| [Gqlgen] | `2,203.00` | `46.94` | `3.02x` |
|| [Apollo GraphQL] | `1,704.66` | `58.58` | `2.34x` |
|| [Netflix DGS] | `1,601.04` | `70.02` | `2.19x` |
|| [GraphQL JIT] | `1,364.98` | `73.16` | `1.87x` |
|| [Hasura] | `729.70` | `137.65` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,206.80` | `1.06` | `28.07x` |
|| [Tailcall] | `59,067.60` | `1.71` | `23.96x` |
|| [async-graphql] | `47,733.90` | `2.15` | `19.36x` |
|| [Gqlgen] | `47,108.30` | `5.04` | `19.11x` |
|| [Netflix DGS] | `8,215.54` | `14.91` | `3.33x` |
|| [Apollo GraphQL] | `7,887.93` | `12.92` | `3.20x` |
|| [GraphQL JIT] | `5,131.72` | `19.45` | `2.08x` |
|| [Hasura] | `2,465.23` | `40.50` | `1.00x` |

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
