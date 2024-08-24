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
|| [Tailcall] | `29,564.10` | `3.37` | `128.97x` |
|| [async-graphql] | `1,984.47` | `50.43` | `8.66x` |
|| [Caliban] | `1,741.56` | `57.28` | `7.60x` |
|| [GraphQL JIT] | `1,361.74` | `73.09` | `5.94x` |
|| [Gqlgen] | `803.68` | `123.50` | `3.51x` |
|| [Netflix DGS] | `365.85` | `173.33` | `1.60x` |
|| [Apollo GraphQL] | `271.48` | `361.37` | `1.18x` |
|| [Hasura] | `229.23` | `446.02` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,620.20` | `1.70` | `77.85x` |
|| [async-graphql] | `10,331.20` | `9.75` | `13.72x` |
|| [Caliban] | `9,811.75` | `10.52` | `13.03x` |
|| [Gqlgen] | `2,224.83` | `46.46` | `2.95x` |
|| [Apollo GraphQL] | `1,754.55` | `56.90` | `2.33x` |
|| [Netflix DGS] | `1,605.96` | `70.60` | `2.13x` |
|| [GraphQL JIT] | `1,403.30` | `71.15` | `1.86x` |
|| [Hasura] | `753.00` | `132.65` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,465.00` | `1.08` | `27.07x` |
|| [Tailcall] | `58,779.00` | `1.72` | `23.59x` |
|| [async-graphql] | `48,459.70` | `2.13` | `19.45x` |
|| [Gqlgen] | `47,722.30` | `5.10` | `19.15x` |
|| [Netflix DGS] | `8,240.82` | `14.81` | `3.31x` |
|| [Apollo GraphQL] | `8,059.75` | `12.61` | `3.23x` |
|| [GraphQL JIT] | `5,244.45` | `19.03` | `2.10x` |
|| [Hasura] | `2,491.87` | `40.43` | `1.00x` |

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
