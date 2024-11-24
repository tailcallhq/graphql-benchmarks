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
|| [Tailcall] | `21,279.50` | `4.69` | `208.21x` |
|| [GraphQL JIT] | `1,146.98` | `86.70` | `11.22x` |
|| [async-graphql] | `1,001.16` | `99.20` | `9.80x` |
|| [Caliban] | `789.90` | `126.11` | `7.73x` |
|| [Gqlgen] | `396.05` | `248.79` | `3.88x` |
|| [Netflix DGS] | `187.47` | `511.84` | `1.83x` |
|| [Apollo GraphQL] | `129.66` | `707.05` | `1.27x` |
|| [Hasura] | `102.20` | `850.62` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,195.00` | `3.01` | `89.17x` |
|| [async-graphql] | `5,154.66` | `19.42` | `13.85x` |
|| [Caliban] | `4,780.47` | `21.43` | `12.84x` |
|| [GraphQL JIT] | `1,179.53` | `84.61` | `3.17x` |
|| [Gqlgen] | `1,110.74` | `98.65` | `2.98x` |
|| [Apollo GraphQL] | `862.54` | `116.25` | `2.32x` |
|| [Netflix DGS] | `798.95` | `125.68` | `2.15x` |
|| [Hasura] | `372.27` | `270.04` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,583.70` | `2.47` | `30.68x` |
|| [Caliban] | `33,235.00` | `3.01` | `25.13x` |
|| [Gqlgen] | `24,156.80` | `8.57` | `18.26x` |
|| [async-graphql] | `24,005.90` | `4.19` | `18.15x` |
|| [GraphQL JIT] | `4,670.51` | `21.36` | `3.53x` |
|| [Netflix DGS] | `4,192.63` | `28.81` | `3.17x` |
|| [Apollo GraphQL] | `3,960.81` | `28.11` | `2.99x` |
|| [Hasura] | `1,322.64` | `75.60` | `1.00x` |

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
