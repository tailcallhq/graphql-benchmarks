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
|| [Tailcall] | `7,592.76` | `13.15` | `64.96x` |
|| [GraphQL JIT] | `1,135.46` | `87.60` | `9.71x` |
|| [async-graphql] | `976.71` | `101.55` | `8.36x` |
|| [Caliban] | `767.47` | `130.74` | `6.57x` |
|| [Gqlgen] | `379.39` | `259.91` | `3.25x` |
|| [Netflix DGS] | `186.98` | `519.87` | `1.60x` |
|| [Apollo GraphQL] | `132.31` | `697.61` | `1.13x` |
|| [Hasura] | `116.88` | `790.19` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,593.80` | `6.42` | `34.04x` |
|| [async-graphql] | `5,153.72` | `19.41` | `11.25x` |
|| [Caliban] | `4,908.78` | `20.85` | `10.72x` |
|| [GraphQL JIT] | `1,170.07` | `85.30` | `2.55x` |
|| [Gqlgen] | `1,102.73` | `99.41` | `2.41x` |
|| [Apollo GraphQL] | `896.75` | `111.90` | `1.96x` |
|| [Netflix DGS] | `799.09` | `125.68` | `1.74x` |
|| [Hasura] | `458.10` | `217.86` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `34,074.80` | `2.94` | `21.95x` |
|| [Gqlgen] | `23,978.00` | `9.76` | `15.44x` |
|| [async-graphql] | `23,472.50` | `4.32` | `15.12x` |
|| [Tailcall] | `20,582.00` | `4.88` | `13.26x` |
|| [GraphQL JIT] | `4,624.03` | `21.59` | `2.98x` |
|| [Netflix DGS] | `4,133.07` | `28.21` | `2.66x` |
|| [Apollo GraphQL] | `4,091.88` | `27.33` | `2.64x` |
|| [Hasura] | `1,552.48` | `64.36` | `1.00x` |

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
