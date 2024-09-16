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
|| [Tailcall] | `17,102.50` | `5.83` | `139.30x` |
|| [GraphQL JIT] | `1,115.18` | `89.14` | `9.08x` |
|| [async-graphql] | `989.17` | `100.47` | `8.06x` |
|| [Caliban] | `725.25` | `137.90` | `5.91x` |
|| [Gqlgen] | `397.25` | `247.92` | `3.24x` |
|| [Netflix DGS] | `186.60` | `521.65` | `1.52x` |
|| [Apollo GraphQL] | `130.13` | `703.58` | `1.06x` |
|| [Hasura] | `122.78` | `682.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,669.60` | `3.26` | `70.91x` |
|| [async-graphql] | `5,162.83` | `19.39` | `11.94x` |
|| [Caliban] | `4,831.87` | `21.08` | `11.17x` |
|| [Gqlgen] | `1,129.00` | `97.50` | `2.61x` |
|| [GraphQL JIT] | `1,123.87` | `88.82` | `2.60x` |
|| [Apollo GraphQL] | `890.91` | `112.61` | `2.06x` |
|| [Netflix DGS] | `815.32` | `124.16` | `1.89x` |
|| [Hasura] | `432.50` | `231.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,916.90` | `2.65` | `24.19x` |
|| [Gqlgen] | `24,638.20` | `9.19` | `15.72x` |
|| [Tailcall] | `23,984.00` | `4.18` | `15.30x` |
|| [async-graphql] | `23,268.10` | `4.31` | `14.85x` |
|| [GraphQL JIT] | `4,437.78` | `22.47` | `2.83x` |
|| [Netflix DGS] | `4,224.00` | `28.51` | `2.70x` |
|| [Apollo GraphQL] | `4,042.15` | `27.33` | `2.58x` |
|| [Hasura] | `1,567.18` | `65.27` | `1.00x` |

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
