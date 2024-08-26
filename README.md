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
|| [Tailcall] | `29,698.70` | `3.35` | `131.08x` |
|| [async-graphql] | `1,989.06` | `50.18` | `8.78x` |
|| [Caliban] | `1,672.04` | `59.53` | `7.38x` |
|| [GraphQL JIT] | `1,379.83` | `72.15` | `6.09x` |
|| [Gqlgen] | `783.19` | `126.71` | `3.46x` |
|| [Netflix DGS] | `363.71` | `220.88` | `1.61x` |
|| [Apollo GraphQL] | `267.86` | `366.25` | `1.18x` |
|| [Hasura] | `226.56` | `434.42` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,531.40` | `1.70` | `82.94x` |
|| [async-graphql] | `10,169.20` | `9.97` | `14.41x` |
|| [Caliban] | `9,685.36` | `10.67` | `13.72x` |
|| [Gqlgen] | `2,209.77` | `46.83` | `3.13x` |
|| [Apollo GraphQL] | `1,738.71` | `57.46` | `2.46x` |
|| [Netflix DGS] | `1,597.69` | `70.29` | `2.26x` |
|| [GraphQL JIT] | `1,413.94` | `70.62` | `2.00x` |
|| [Hasura] | `705.68` | `142.60` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,380.00` | `1.05` | `26.70x` |
|| [Tailcall] | `58,579.10` | `1.72` | `23.22x` |
|| [Gqlgen] | `47,668.00` | `5.03` | `18.89x` |
|| [async-graphql] | `47,405.30` | `2.14` | `18.79x` |
|| [Netflix DGS] | `8,277.61` | `14.68` | `3.28x` |
|| [Apollo GraphQL] | `7,945.60` | `12.81` | `3.15x` |
|| [GraphQL JIT] | `5,279.54` | `18.91` | `2.09x` |
|| [Hasura] | `2,523.22` | `40.04` | `1.00x` |

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
