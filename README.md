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
|| [Tailcall] | `18,139.30` | `5.50` | `157.25x` |
|| [GraphQL JIT] | `1,134.49` | `87.68` | `9.83x` |
|| [async-graphql] | `949.99` | `104.79` | `8.24x` |
|| [Caliban] | `741.36` | `135.51` | `6.43x` |
|| [Gqlgen] | `369.80` | `266.63` | `3.21x` |
|| [Netflix DGS] | `189.89` | `510.07` | `1.65x` |
|| [Apollo GraphQL] | `131.24` | `700.22` | `1.14x` |
|| [Hasura] | `115.35` | `788.71` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,352.30` | `3.29` | `70.86x` |
|| [async-graphql] | `4,889.52` | `20.46` | `11.41x` |
|| [Caliban] | `4,789.44` | `21.32` | `11.18x` |
|| [GraphQL JIT] | `1,169.24` | `85.35` | `2.73x` |
|| [Gqlgen] | `1,083.61` | `101.04` | `2.53x` |
|| [Apollo GraphQL] | `897.33` | `111.92` | `2.09x` |
|| [Netflix DGS] | `817.20` | `123.09` | `1.91x` |
|| [Hasura] | `428.35` | `243.69` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,109.50` | `2.69` | `24.34x` |
|| [Tailcall] | `23,781.20` | `4.22` | `15.60x` |
|| [Gqlgen] | `23,255.70` | `12.38` | `15.25x` |
|| [async-graphql] | `22,840.00` | `4.43` | `14.98x` |
|| [GraphQL JIT] | `4,664.36` | `21.39` | `3.06x` |
|| [Netflix DGS] | `4,263.72` | `28.07` | `2.80x` |
|| [Apollo GraphQL] | `4,039.87` | `27.15` | `2.65x` |
|| [Hasura] | `1,524.92` | `69.65` | `1.00x` |

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
