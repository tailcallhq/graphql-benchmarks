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
|| [Tailcall] | `21,624.00` | `4.62` | `189.04x` |
|| [GraphQL JIT] | `1,120.83` | `88.66` | `9.80x` |
|| [async-graphql] | `989.70` | `100.26` | `8.65x` |
|| [Caliban] | `779.16` | `128.93` | `6.81x` |
|| [Gqlgen] | `379.88` | `259.19` | `3.32x` |
|| [Netflix DGS] | `187.87` | `515.41` | `1.64x` |
|| [Apollo GraphQL] | `127.24` | `713.40` | `1.11x` |
|| [Hasura] | `114.39` | `783.02` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,741.40` | `2.96` | `76.41x` |
|| [async-graphql] | `5,146.86` | `19.48` | `11.66x` |
|| [Caliban] | `4,934.71` | `20.73` | `11.18x` |
|| [GraphQL JIT] | `1,137.19` | `87.76` | `2.58x` |
|| [Gqlgen] | `1,107.02` | `98.92` | `2.51x` |
|| [Apollo GraphQL] | `873.89` | `114.80` | `1.98x` |
|| [Netflix DGS] | `815.62` | `122.99` | `1.85x` |
|| [Hasura] | `441.58` | `234.46` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `41,016.70` | `2.44` | `26.52x` |
|| [Caliban] | `32,543.50` | `3.09` | `21.04x` |
|| [Gqlgen] | `24,659.50` | `10.11` | `15.95x` |
|| [async-graphql] | `23,468.20` | `4.27` | `15.18x` |
|| [GraphQL JIT] | `4,575.12` | `21.82` | `2.96x` |
|| [Netflix DGS] | `4,251.93` | `27.53` | `2.75x` |
|| [Apollo GraphQL] | `4,039.48` | `27.70` | `2.61x` |
|| [Hasura] | `1,546.42` | `68.74` | `1.00x` |

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
