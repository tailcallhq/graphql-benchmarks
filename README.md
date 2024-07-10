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
|| [Tailcall] | `29,633.10` | `3.36` | `107.67x` |
|| [async-graphql] | `1,905.97` | `52.30` | `6.93x` |
|| [Caliban] | `1,574.95` | `63.11` | `5.72x` |
|| [Hasura] | `1,549.09` | `64.67` | `5.63x` |
|| [GraphQL JIT] | `1,396.13` | `75.23` | `5.07x` |
|| [Gqlgen] | `742.36` | `133.66` | `2.70x` |
|| [Netflix DGS] | `354.63` | `224.42` | `1.29x` |
|| [Apollo GraphQL] | `275.22` | `357.55` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,245.50` | `1.62` | `43.33x` |
|| [async-graphql] | `9,355.65` | `11.00` | `6.62x` |
|| [Caliban] | `9,183.25` | `11.23` | `6.50x` |
|| [Hasura] | `2,447.54` | `40.82` | `1.73x` |
|| [Gqlgen] | `2,201.21` | `47.10` | `1.56x` |
|| [Apollo GraphQL] | `1,676.24` | `59.58` | `1.19x` |
|| [Netflix DGS] | `1,587.10` | `70.18` | `1.12x` |
|| [GraphQL JIT] | `1,413.40` | `72.00` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,307.20` | `1.14` | `26.61x` |
|| [Tailcall] | `62,914.00` | `1.60` | `25.25x` |
|| [async-graphql] | `51,082.60` | `2.02` | `20.50x` |
|| [Gqlgen] | `47,132.60` | `5.24` | `18.91x` |
|| [Netflix DGS] | `8,237.39` | `14.43` | `3.31x` |
|| [Apollo GraphQL] | `7,730.77` | `13.18` | `3.10x` |
|| [GraphQL JIT] | `5,219.77` | `27.05` | `2.09x` |
|| [Hasura] | `2,491.89` | `40.03` | `1.00x` |

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
