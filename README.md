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
|| [Tailcall] | `21,514.00` | `4.64` | `179.87x` |
|| [GraphQL JIT] | `1,142.45` | `87.08` | `9.55x` |
|| [async-graphql] | `946.77` | `104.82` | `7.92x` |
|| [Caliban] | `748.22` | `134.04` | `6.26x` |
|| [Gqlgen] | `382.50` | `257.69` | `3.20x` |
|| [Netflix DGS] | `190.53` | `507.59` | `1.59x` |
|| [Apollo GraphQL] | `128.22` | `713.79` | `1.07x` |
|| [Hasura] | `119.61` | `791.12` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,390.10` | `3.00` | `78.82x` |
|| [async-graphql] | `5,171.59` | `19.40` | `12.21x` |
|| [Caliban] | `4,834.18` | `21.17` | `11.41x` |
|| [GraphQL JIT] | `1,188.43` | `83.99` | `2.81x` |
|| [Gqlgen] | `1,088.02` | `100.37` | `2.57x` |
|| [Apollo GraphQL] | `874.77` | `114.70` | `2.06x` |
|| [Netflix DGS] | `811.87` | `123.62` | `1.92x` |
|| [Hasura] | `423.63` | `244.95` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,893.60` | `2.57` | `24.88x` |
|| [Caliban] | `32,999.20` | `3.05` | `21.11x` |
|| [Gqlgen] | `23,801.90` | `9.60` | `15.23x` |
|| [async-graphql] | `23,617.10` | `4.27` | `15.11x` |
|| [GraphQL JIT] | `4,734.44` | `21.07` | `3.03x` |
|| [Netflix DGS] | `4,221.82` | `27.78` | `2.70x` |
|| [Apollo GraphQL] | `4,028.80` | `27.54` | `2.58x` |
|| [Hasura] | `1,563.31` | `64.13` | `1.00x` |

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
