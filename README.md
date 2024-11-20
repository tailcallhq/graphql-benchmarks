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
|| [Tailcall] | `18,271.80` | `5.47` | `155.68x` |
|| [GraphQL JIT] | `1,117.67` | `88.93` | `9.52x` |
|| [async-graphql] | `965.87` | `102.69` | `8.23x` |
|| [Caliban] | `757.44` | `132.52` | `6.45x` |
|| [Gqlgen] | `380.89` | `258.78` | `3.25x` |
|| [Netflix DGS] | `189.30` | `511.89` | `1.61x` |
|| [Apollo GraphQL] | `129.80` | `703.70` | `1.11x` |
|| [Hasura] | `117.37` | `785.04` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,341.80` | `3.20` | `68.32x` |
|| [async-graphql] | `4,987.12` | `20.09` | `10.87x` |
|| [Caliban] | `4,890.69` | `20.94` | `10.66x` |
|| [GraphQL JIT] | `1,151.52` | `86.67` | `2.51x` |
|| [Gqlgen] | `1,109.42` | `98.70` | `2.42x` |
|| [Apollo GraphQL] | `889.32` | `113.14` | `1.94x` |
|| [Netflix DGS] | `807.91` | `124.17` | `1.76x` |
|| [Hasura] | `458.75` | `219.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,395.80` | `2.62` | `26.49x` |
|| [Caliban] | `33,062.10` | `3.02` | `22.81x` |
|| [Gqlgen] | `24,083.90` | `9.61` | `16.62x` |
|| [async-graphql] | `23,551.70` | `4.27` | `16.25x` |
|| [GraphQL JIT] | `4,547.67` | `21.94` | `3.14x` |
|| [Netflix DGS] | `4,204.97` | `28.09` | `2.90x` |
|| [Apollo GraphQL] | `4,045.00` | `27.18` | `2.79x` |
|| [Hasura] | `1,449.36` | `68.79` | `1.00x` |

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
