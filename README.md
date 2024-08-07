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
|| [Tailcall] | `27,838.70` | `3.58` | `225.19x` |
|| [async-graphql] | `2,008.93` | `50.35` | `16.25x` |
|| [Caliban] | `1,757.87` | `56.64` | `14.22x` |
|| [GraphQL JIT] | `1,345.94` | `74.01` | `10.89x` |
|| [Gqlgen] | `791.58` | `125.36` | `6.40x` |
|| [Netflix DGS] | `354.46` | `185.22` | `2.87x` |
|| [Apollo GraphQL] | `260.71` | `377.68` | `2.11x` |
|| [Hasura] | `123.62` | `458.40` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `56,812.60` | `1.75` | `65.61x` |
|| [async-graphql] | `9,955.86` | `10.14` | `11.50x` |
|| [Caliban] | `9,815.99` | `10.52` | `11.34x` |
|| [Gqlgen] | `2,206.03` | `46.90` | `2.55x` |
|| [Apollo GraphQL] | `1,690.11` | `59.12` | `1.95x` |
|| [Netflix DGS] | `1,571.62` | `71.18` | `1.81x` |
|| [GraphQL JIT] | `1,393.13` | `71.68` | `1.61x` |
|| [Hasura] | `865.95` | `115.23` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,354.80` | `1.09` | `25.80x` |
|| [Tailcall] | `59,460.40` | `1.70` | `22.78x` |
|| [async-graphql] | `48,070.30` | `2.08` | `18.42x` |
|| [Gqlgen] | `47,552.90` | `5.18` | `18.22x` |
|| [Netflix DGS] | `8,119.94` | `15.39` | `3.11x` |
|| [Apollo GraphQL] | `7,886.65` | `12.96` | `3.02x` |
|| [GraphQL JIT] | `5,228.24` | `19.10` | `2.00x` |
|| [Hasura] | `2,610.32` | `38.21` | `1.00x` |

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
