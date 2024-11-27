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
|| [Tailcall] | `20,879.50` | `4.78` | `179.91x` |
|| [GraphQL JIT] | `1,122.02` | `88.56` | `9.67x` |
|| [async-graphql] | `1,005.95` | `98.64` | `8.67x` |
|| [Caliban] | `764.28` | `131.79` | `6.59x` |
|| [Gqlgen] | `368.37` | `267.35` | `3.17x` |
|| [Netflix DGS] | `188.49` | `510.65` | `1.62x` |
|| [Apollo GraphQL] | `128.52` | `713.13` | `1.11x` |
|| [Hasura] | `116.06` | `766.53` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,370.70` | `3.09` | `71.60x` |
|| [async-graphql] | `5,157.46` | `19.44` | `11.41x` |
|| [Caliban] | `4,797.36` | `21.39` | `10.61x` |
|| [GraphQL JIT] | `1,156.53` | `86.28` | `2.56x` |
|| [Gqlgen] | `1,062.62` | `103.73` | `2.35x` |
|| [Apollo GraphQL] | `851.61` | `117.81` | `1.88x` |
|| [Netflix DGS] | `810.41` | `124.13` | `1.79x` |
|| [Hasura] | `452.09` | `245.97` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,960.00` | `2.57` | `28.32x` |
|| [Caliban] | `33,124.20` | `3.02` | `24.08x` |
|| [async-graphql] | `24,019.40` | `4.19` | `17.46x` |
|| [Gqlgen] | `22,888.30` | `8.79` | `16.64x` |
|| [GraphQL JIT] | `4,643.23` | `21.49` | `3.37x` |
|| [Netflix DGS] | `4,221.01` | `28.53` | `3.07x` |
|| [Apollo GraphQL] | `4,005.36` | `28.18` | `2.91x` |
|| [Hasura] | `1,375.78` | `73.33` | `1.00x` |

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
