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
|| [Tailcall] | `1,097.96` | `90.55` | `10.02x` |
|| [GraphQL JIT] | `1,072.39` | `92.73` | `9.79x` |
|| [async-graphql] | `1,039.03` | `95.63` | `9.48x` |
|| [Caliban] | `892.75` | `112.56` | `8.15x` |
|| [Gqlgen] | `391.49` | `251.90` | `3.57x` |
|| [Netflix DGS] | `185.55` | `525.82` | `1.69x` |
|| [Apollo GraphQL] | `130.92` | `700.84` | `1.20x` |
|| [Hasura] | `109.55` | `747.68` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,715.62` | `17.54` | `13.74x` |
|| [async-graphql] | `5,275.20` | `18.94` | `12.68x` |
|| [Tailcall] | `3,804.62` | `26.26` | `9.15x` |
|| [GraphQL JIT] | `1,145.75` | `87.06` | `2.75x` |
|| [Gqlgen] | `1,104.79` | `99.51` | `2.66x` |
|| [Apollo GraphQL] | `893.05` | `112.41` | `2.15x` |
|| [Netflix DGS] | `806.11` | `157.15` | `1.94x` |
|| [Hasura] | `415.93` | `242.95` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `45,938.20` | `2.12` | `29.73x` |
|| [Gqlgen] | `25,385.70` | `4.92` | `16.43x` |
|| [async-graphql] | `24,925.00` | `4.00` | `16.13x` |
|| [Tailcall] | `21,207.40` | `4.73` | `13.72x` |
|| [GraphQL JIT] | `4,533.50` | `22.02` | `2.93x` |
|| [Netflix DGS] | `4,131.76` | `27.97` | `2.67x` |
|| [Apollo GraphQL] | `4,089.25` | `29.05` | `2.65x` |
|| [Hasura] | `1,545.36` | `65.81` | `1.00x` |

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
