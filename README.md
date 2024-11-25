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
|| [Tailcall] | `21,384.80` | `4.67` | `200.20x` |
|| [GraphQL JIT] | `1,119.58` | `88.83` | `10.48x` |
|| [async-graphql] | `1,021.69` | `97.09` | `9.56x` |
|| [Caliban] | `766.26` | `130.26` | `7.17x` |
|| [Gqlgen] | `374.50` | `263.10` | `3.51x` |
|| [Netflix DGS] | `186.94` | `516.98` | `1.75x` |
|| [Apollo GraphQL] | `125.95` | `723.01` | `1.18x` |
|| [Hasura] | `106.82` | `738.68` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,574.60` | `3.07` | `79.34x` |
|| [async-graphql] | `5,231.21` | `19.38` | `12.74x` |
|| [Caliban] | `4,915.68` | `20.76` | `11.97x` |
|| [GraphQL JIT] | `1,123.55` | `88.83` | `2.74x` |
|| [Gqlgen] | `1,071.11` | `102.49` | `2.61x` |
|| [Apollo GraphQL] | `862.14` | `116.58` | `2.10x` |
|| [Netflix DGS] | `803.11` | `125.26` | `1.96x` |
|| [Hasura] | `410.55` | `242.93` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,185.10` | `2.56` | `30.02x` |
|| [Caliban] | `33,559.80` | `2.98` | `25.71x` |
|| [async-graphql] | `23,755.10` | `4.22` | `18.20x` |
|| [Gqlgen] | `23,749.40` | `8.22` | `18.20x` |
|| [GraphQL JIT] | `4,501.42` | `22.17` | `3.45x` |
|| [Netflix DGS] | `4,151.41` | `28.72` | `3.18x` |
|| [Apollo GraphQL] | `3,989.04` | `28.41` | `3.06x` |
|| [Hasura] | `1,305.13` | `76.28` | `1.00x` |

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
