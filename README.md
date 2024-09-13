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
|| [Tailcall] | `18,189.40` | `5.49` | `152.18x` |
|| [GraphQL JIT] | `1,101.13` | `90.22` | `9.21x` |
|| [async-graphql] | `919.18` | `107.97` | `7.69x` |
|| [Caliban] | `751.82` | `133.14` | `6.29x` |
|| [Gqlgen] | `385.50` | `255.72` | `3.23x` |
|| [Netflix DGS] | `192.78` | `503.72` | `1.61x` |
|| [Apollo GraphQL] | `128.18` | `712.53` | `1.07x` |
|| [Hasura] | `119.53` | `761.54` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,976.80` | `3.22` | `73.51x` |
|| [async-graphql] | `4,891.78` | `20.47` | `11.61x` |
|| [Caliban] | `4,842.44` | `21.12` | `11.49x` |
|| [GraphQL JIT] | `1,148.58` | `86.90` | `2.73x` |
|| [Gqlgen] | `1,094.29` | `100.32` | `2.60x` |
|| [Apollo GraphQL] | `856.33` | `117.24` | `2.03x` |
|| [Netflix DGS] | `819.26` | `122.88` | `1.94x` |
|| [Hasura] | `421.41` | `236.21` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,577.10` | `2.65` | `23.51x` |
|| [Gqlgen] | `24,616.10` | `9.62` | `15.40x` |
|| [Tailcall] | `24,181.40` | `4.14` | `15.13x` |
|| [async-graphql] | `23,310.30` | `4.32` | `14.59x` |
|| [GraphQL JIT] | `4,640.72` | `21.49` | `2.90x` |
|| [Netflix DGS] | `4,214.01` | `28.66` | `2.64x` |
|| [Apollo GraphQL] | `3,874.00` | `28.41` | `2.42x` |
|| [Hasura] | `1,598.22` | `64.59` | `1.00x` |

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
