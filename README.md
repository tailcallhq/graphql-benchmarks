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
|| [Tailcall] | `21,941.80` | `4.54` | `192.59x` |
|| [GraphQL JIT] | `1,144.08` | `86.92` | `10.04x` |
|| [async-graphql] | `971.32` | `102.17` | `8.53x` |
|| [Caliban] | `759.85` | `132.01` | `6.67x` |
|| [Gqlgen] | `381.55` | `258.10` | `3.35x` |
|| [Netflix DGS] | `184.39` | `523.13` | `1.62x` |
|| [Apollo GraphQL] | `132.62` | `692.39` | `1.16x` |
|| [Hasura] | `113.93` | `793.40` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,248.50` | `3.01` | `80.98x` |
|| [async-graphql] | `4,970.74` | `20.14` | `12.11x` |
|| [Caliban] | `4,857.95` | `21.09` | `11.83x` |
|| [GraphQL JIT] | `1,174.58` | `84.97` | `2.86x` |
|| [Gqlgen] | `1,126.34` | `97.67` | `2.74x` |
|| [Apollo GraphQL] | `894.26` | `112.23` | `2.18x` |
|| [Netflix DGS] | `790.40` | `127.56` | `1.93x` |
|| [Hasura] | `410.57` | `245.72` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,563.50` | `2.47` | `26.38x` |
|| [Caliban] | `33,854.40` | `2.96` | `22.02x` |
|| [Gqlgen] | `24,627.40` | `10.40` | `16.02x` |
|| [async-graphql] | `23,179.90` | `4.35` | `15.07x` |
|| [GraphQL JIT] | `4,657.61` | `21.43` | `3.03x` |
|| [Netflix DGS] | `4,128.29` | `28.76` | `2.68x` |
|| [Apollo GraphQL] | `4,104.05` | `26.95` | `2.67x` |
|| [Hasura] | `1,537.77` | `64.86` | `1.00x` |

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
