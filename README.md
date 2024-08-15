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
|| [Tailcall] | `29,664.50` | `3.36` | `125.56x` |
|| [async-graphql] | `1,987.64` | `50.21` | `8.41x` |
|| [Caliban] | `1,745.95` | `57.03` | `7.39x` |
|| [GraphQL JIT] | `1,312.99` | `75.84` | `5.56x` |
|| [Gqlgen] | `768.12` | `129.19` | `3.25x` |
|| [Netflix DGS] | `364.20` | `165.08` | `1.54x` |
|| [Apollo GraphQL] | `266.24` | `368.81` | `1.13x` |
|| [Hasura] | `236.26` | `420.59` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,014.40` | `1.69` | `82.78x` |
|| [async-graphql] | `10,278.60` | `9.81` | `14.42x` |
|| [Caliban] | `9,809.80` | `10.55` | `13.76x` |
|| [Gqlgen] | `2,128.08` | `48.71` | `2.98x` |
|| [Apollo GraphQL] | `1,759.93` | `56.72` | `2.47x` |
|| [Netflix DGS] | `1,575.76` | `71.19` | `2.21x` |
|| [GraphQL JIT] | `1,353.04` | `73.79` | `1.90x` |
|| [Hasura] | `712.93` | `142.01` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,512.60` | `1.08` | `27.55x` |
|| [Tailcall] | `59,480.40` | `1.69` | `24.27x` |
|| [async-graphql] | `46,725.30` | `2.31` | `19.07x` |
|| [Gqlgen] | `45,941.10` | `5.24` | `18.75x` |
|| [Apollo GraphQL] | `8,078.91` | `12.57` | `3.30x` |
|| [Netflix DGS] | `8,061.13` | `14.92` | `3.29x` |
|| [GraphQL JIT] | `5,078.81` | `19.67` | `2.07x` |
|| [Hasura] | `2,450.28` | `41.12` | `1.00x` |

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
