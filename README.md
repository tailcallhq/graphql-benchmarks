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
|| [Tailcall] | `8,119.35` | `12.28` | `69.91x` |
|| [GraphQL JIT] | `1,139.48` | `87.26` | `9.81x` |
|| [async-graphql] | `1,003.06` | `98.90` | `8.64x` |
|| [Caliban] | `741.77` | `134.53` | `6.39x` |
|| [Gqlgen] | `386.98` | `254.83` | `3.33x` |
|| [Netflix DGS] | `190.47` | `509.06` | `1.64x` |
|| [Apollo GraphQL] | `129.31` | `708.27` | `1.11x` |
|| [Hasura] | `116.14` | `800.41` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,993.40` | `6.25` | `35.92x` |
|| [async-graphql] | `5,278.25` | `18.95` | `11.85x` |
|| [Caliban] | `4,806.90` | `21.27` | `10.80x` |
|| [GraphQL JIT] | `1,181.07` | `84.52` | `2.65x` |
|| [Gqlgen] | `1,102.17` | `99.10` | `2.48x` |
|| [Apollo GraphQL] | `886.68` | `113.14` | `1.99x` |
|| [Netflix DGS] | `807.55` | `124.61` | `1.81x` |
|| [Hasura] | `445.27` | `232.78` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,009.30` | `3.05` | `21.49x` |
|| [Gqlgen] | `24,379.00` | `8.80` | `15.87x` |
|| [async-graphql] | `23,743.90` | `4.23` | `15.46x` |
|| [Tailcall] | `20,883.00` | `4.81` | `13.59x` |
|| [GraphQL JIT] | `4,650.85` | `21.46` | `3.03x` |
|| [Netflix DGS] | `4,170.88` | `28.34` | `2.72x` |
|| [Apollo GraphQL] | `4,022.45` | `27.40` | `2.62x` |
|| [Hasura] | `1,536.12` | `67.23` | `1.00x` |

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
