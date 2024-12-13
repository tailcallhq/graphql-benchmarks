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
|| [Tailcall] | `60,849.00` | `1.63` | `540.11x` |
|| [GraphQL JIT] | `1,089.05` | `91.37` | `9.67x` |
|| [async-graphql] | `935.21` | `106.28` | `8.30x` |
|| [Caliban] | `706.01` | `141.64` | `6.27x` |
|| [Gqlgen] | `391.84` | `251.36` | `3.48x` |
|| [Netflix DGS] | `177.96` | `544.50` | `1.58x` |
|| [Apollo GraphQL] | `126.34` | `717.73` | `1.12x` |
|| [Hasura] | `112.66` | `802.47` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `129,494.00` | `767.11` | `312.87x` |
|| [async-graphql] | `4,747.62` | `21.10` | `11.47x` |
|| [Caliban] | `4,619.50` | `22.18` | `11.16x` |
|| [GraphQL JIT] | `1,127.79` | `88.47` | `2.72x` |
|| [Gqlgen] | `1,121.66` | `97.45` | `2.71x` |
|| [Apollo GraphQL] | `850.53` | `118.05` | `2.05x` |
|| [Netflix DGS] | `779.80` | `128.54` | `1.88x` |
|| [Hasura] | `413.90` | `258.64` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `241,543.00` | `452.02` | `152.26x` |
|| [Caliban] | `32,710.10` | `3.06` | `20.62x` |
|| [Gqlgen] | `24,269.50` | `8.75` | `15.30x` |
|| [async-graphql] | `23,196.70` | `4.30` | `14.62x` |
|| [GraphQL JIT] | `4,492.87` | `22.21` | `2.83x` |
|| [Netflix DGS] | `4,094.51` | `28.30` | `2.58x` |
|| [Apollo GraphQL] | `3,940.14` | `28.15` | `2.48x` |
|| [Hasura] | `1,586.39` | `69.65` | `1.00x` |

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
