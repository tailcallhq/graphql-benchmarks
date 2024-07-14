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
|| [Tailcall] | `29,922.20` | `3.33` | `112.12x` |
|| [async-graphql] | `1,867.29` | `54.01` | `7.00x` |
|| [Caliban] | `1,568.68` | `63.70` | `5.88x` |
|| [Hasura] | `1,493.31` | `66.79` | `5.60x` |
|| [GraphQL JIT] | `1,338.18` | `74.42` | `5.01x` |
|| [Gqlgen] | `770.57` | `128.83` | `2.89x` |
|| [Netflix DGS] | `356.89` | `246.24` | `1.34x` |
|| [Apollo GraphQL] | `266.88` | `367.39` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,054.00` | `1.60` | `45.17x` |
|| [async-graphql] | `9,456.44` | `10.70` | `6.88x` |
|| [Caliban] | `9,318.68` | `11.08` | `6.78x` |
|| [Hasura] | `2,447.49` | `40.84` | `1.78x` |
|| [Gqlgen] | `2,167.07` | `47.82` | `1.58x` |
|| [Apollo GraphQL] | `1,745.49` | `57.21` | `1.27x` |
|| [Netflix DGS] | `1,601.17` | `68.94` | `1.17x` |
|| [GraphQL JIT] | `1,373.75` | `72.69` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,335.30` | `1.05` | `27.05x` |
|| [Tailcall] | `64,385.60` | `1.56` | `25.49x` |
|| [async-graphql] | `51,682.70` | `1.98` | `20.46x` |
|| [Gqlgen] | `47,207.70` | `5.07` | `18.69x` |
|| [Netflix DGS] | `8,248.13` | `14.56` | `3.26x` |
|| [Apollo GraphQL] | `7,931.10` | `12.95` | `3.14x` |
|| [GraphQL JIT] | `5,176.81` | `19.29` | `2.05x` |
|| [Hasura] | `2,526.31` | `39.52` | `1.00x` |

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
