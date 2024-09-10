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
|| [Tailcall] | `18,113.10` | `5.51` | `154.24x` |
|| [GraphQL JIT] | `1,095.66` | `90.76` | `9.33x` |
|| [async-graphql] | `935.96` | `106.04` | `7.97x` |
|| [Caliban] | `723.85` | `138.14` | `6.16x` |
|| [Gqlgen] | `402.01` | `245.42` | `3.42x` |
|| [Netflix DGS] | `191.56` | `507.03` | `1.63x` |
|| [Apollo GraphQL] | `129.50` | `708.31` | `1.10x` |
|| [Hasura] | `117.44` | `766.03` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,453.00` | `3.28` | `68.27x` |
|| [async-graphql] | `4,973.81` | `20.23` | `11.15x` |
|| [Caliban] | `4,804.82` | `21.26` | `10.77x` |
|| [GraphQL JIT] | `1,140.65` | `87.51` | `2.56x` |
|| [Gqlgen] | `1,132.36` | `97.10` | `2.54x` |
|| [Apollo GraphQL] | `885.01` | `113.50` | `1.98x` |
|| [Netflix DGS] | `820.68` | `122.74` | `1.84x` |
|| [Hasura] | `446.06` | `233.61` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `38,417.60` | `2.59` | `25.90x` |
|| [Gqlgen] | `24,693.30` | `9.78` | `16.65x` |
|| [Tailcall] | `23,917.20` | `4.18` | `16.12x` |
|| [async-graphql] | `23,499.90` | `4.26` | `15.84x` |
|| [GraphQL JIT] | `4,535.70` | `22.01` | `3.06x` |
|| [Netflix DGS] | `4,224.72` | `28.47` | `2.85x` |
|| [Apollo GraphQL] | `4,016.17` | `27.72` | `2.71x` |
|| [Hasura] | `1,483.43` | `68.93` | `1.00x` |

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
