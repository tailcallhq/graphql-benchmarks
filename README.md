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
|| [Tailcall] | `21,657.40` | `4.61` | `182.79x` |
|| [GraphQL JIT] | `1,129.26` | `88.05` | `9.53x` |
|| [async-graphql] | `1,021.02` | `97.23` | `8.62x` |
|| [Caliban] | `776.59` | `128.88` | `6.55x` |
|| [Gqlgen] | `380.13` | `259.19` | `3.21x` |
|| [Netflix DGS] | `191.22` | `507.46` | `1.61x` |
|| [Apollo GraphQL] | `129.96` | `706.99` | `1.10x` |
|| [Hasura] | `118.48` | `765.26` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,656.80` | `3.06` | `75.85x` |
|| [async-graphql] | `5,216.97` | `19.18` | `12.12x` |
|| [Caliban] | `4,833.95` | `21.23` | `11.23x` |
|| [GraphQL JIT] | `1,163.41` | `85.78` | `2.70x` |
|| [Gqlgen] | `1,099.13` | `99.67` | `2.55x` |
|| [Apollo GraphQL] | `901.74` | `111.14` | `2.09x` |
|| [Netflix DGS] | `822.76` | `122.71` | `1.91x` |
|| [Hasura] | `430.55` | `236.28` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,779.10` | `2.58` | `27.26x` |
|| [Caliban] | `33,484.10` | `3.02` | `23.54x` |
|| [async-graphql] | `24,076.70` | `4.15` | `16.92x` |
|| [Gqlgen] | `23,968.90` | `9.96` | `16.85x` |
|| [GraphQL JIT] | `4,550.43` | `21.93` | `3.20x` |
|| [Netflix DGS] | `4,311.41` | `27.84` | `3.03x` |
|| [Apollo GraphQL] | `4,020.78` | `28.05` | `2.83x` |
|| [Hasura] | `1,422.61` | `71.80` | `1.00x` |

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
