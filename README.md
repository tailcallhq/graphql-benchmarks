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
|| [Tailcall] | `20,806.60` | `4.79` | `184.26x` |
|| [GraphQL JIT] | `1,109.79` | `89.55` | `9.83x` |
|| [async-graphql] | `987.61` | `100.48` | `8.75x` |
|| [Caliban] | `740.21` | `135.22` | `6.56x` |
|| [Gqlgen] | `385.67` | `255.64` | `3.42x` |
|| [Netflix DGS] | `184.50` | `526.69` | `1.63x` |
|| [Apollo GraphQL] | `129.30` | `705.97` | `1.15x` |
|| [Hasura] | `112.92` | `768.50` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,814.40` | `3.25` | `69.08x` |
|| [async-graphql] | `4,996.03` | `20.03` | `11.20x` |
|| [Caliban] | `4,729.76` | `21.66` | `10.60x` |
|| [GraphQL JIT] | `1,155.95` | `86.36` | `2.59x` |
|| [Gqlgen] | `1,140.28` | `96.26` | `2.56x` |
|| [Apollo GraphQL] | `873.78` | `114.94` | `1.96x` |
|| [Netflix DGS] | `799.51` | `126.15` | `1.79x` |
|| [Hasura] | `446.10` | `227.69` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `37,215.70` | `2.68` | `23.78x` |
|| [Caliban] | `33,581.40` | `2.99` | `21.45x` |
|| [Gqlgen] | `24,620.50` | `9.10` | `15.73x` |
|| [async-graphql] | `23,800.90` | `4.22` | `15.21x` |
|| [GraphQL JIT] | `4,614.20` | `21.61` | `2.95x` |
|| [Netflix DGS] | `4,121.12` | `28.57` | `2.63x` |
|| [Apollo GraphQL] | `3,962.66` | `28.27` | `2.53x` |
|| [Hasura] | `1,565.24` | `64.84` | `1.00x` |

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
