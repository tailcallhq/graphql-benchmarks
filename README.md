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
|| [Tailcall] | `29,890.70` | `3.33` | `184.82x` |
|| [async-graphql] | `1,998.31` | `50.11` | `12.36x` |
|| [Caliban] | `1,780.26` | `55.98` | `11.01x` |
|| [GraphQL JIT] | `1,333.09` | `74.70` | `8.24x` |
|| [Gqlgen] | `791.99` | `125.34` | `4.90x` |
|| [Netflix DGS] | `370.11` | `218.90` | `2.29x` |
|| [Apollo GraphQL] | `270.23` | `364.01` | `1.67x` |
|| [Hasura] | `161.73` | `561.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,217.00` | `1.71` | `69.07x` |
|| [async-graphql] | `9,904.22` | `10.24` | `11.75x` |
|| [Caliban] | `9,833.57` | `10.48` | `11.67x` |
|| [Gqlgen] | `2,198.70` | `47.05` | `2.61x` |
|| [Apollo GraphQL] | `1,767.95` | `56.45` | `2.10x` |
|| [Netflix DGS] | `1,623.19` | `69.18` | `1.93x` |
|| [GraphQL JIT] | `1,385.72` | `72.05` | `1.64x` |
|| [Hasura] | `842.83` | `118.38` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,659.30` | `1.08` | `26.38x` |
|| [Tailcall] | `59,257.10` | `1.71` | `23.11x` |
|| [async-graphql] | `47,944.10` | `2.14` | `18.69x` |
|| [Gqlgen] | `47,681.70` | `5.06` | `18.59x` |
|| [Netflix DGS] | `8,442.58` | `14.53` | `3.29x` |
|| [Apollo GraphQL] | `8,067.08` | `12.59` | `3.15x` |
|| [GraphQL JIT] | `5,314.87` | `18.79` | `2.07x` |
|| [Hasura] | `2,564.56` | `38.90` | `1.00x` |

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
