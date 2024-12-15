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
|| [Tailcall] | `21,101.80` | `4.73` | `188.66x` |
|| [Gqlgen] | `2,409.59` | `41.60` | `21.54x` |
|| [GraphQL JIT] | `2,317.78` | `43.04` | `20.72x` |
|| [async-graphql] | `1,022.03` | `97.18` | `9.14x` |
|| [Caliban] | `781.83` | `127.37` | `6.99x` |
|| [Netflix DGS] | `189.96` | `507.65` | `1.70x` |
|| [Apollo GraphQL] | `130.43` | `705.67` | `1.17x` |
|| [Hasura] | `111.85` | `804.26` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,456.20` | `3.18` | `75.31x` |
|| [Gqlgen] | `8,048.47` | `13.64` | `19.27x` |
|| [async-graphql] | `5,218.03` | `19.22` | `12.49x` |
|| [Caliban] | `4,785.54` | `21.46` | `11.46x` |
|| [GraphQL JIT] | `2,331.60` | `42.87` | `5.58x` |
|| [Apollo GraphQL] | `885.85` | `113.18` | `2.12x` |
|| [Netflix DGS] | `804.64` | `125.04` | `1.93x` |
|| [Hasura] | `417.67` | `246.91` | `1.00x` |
| 3 | `{ greet }` |
|| [Gqlgen] | `177,076.00` | `753.86` | `117.96x` |
|| [Tailcall] | `38,493.10` | `2.60` | `25.64x` |
|| [Caliban] | `32,841.20` | `3.04` | `21.88x` |
|| [async-graphql] | `23,887.90` | `4.20` | `15.91x` |
|| [GraphQL JIT] | `8,802.26` | `11.35` | `5.86x` |
|| [Netflix DGS] | `4,239.40` | `27.84` | `2.82x` |
|| [Apollo GraphQL] | `4,025.78` | `27.42` | `2.68x` |
|| [Hasura] | `1,501.12` | `66.61` | `1.00x` |

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
