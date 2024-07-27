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
|| [Tailcall] | `29,511.10` | `3.38` | `232.90x` |
|| [async-graphql] | `2,003.02` | `49.90` | `15.81x` |
|| [Caliban] | `1,666.82` | `59.87` | `13.15x` |
|| [GraphQL JIT] | `1,335.11` | `74.62` | `10.54x` |
|| [Gqlgen] | `792.20` | `125.25` | `6.25x` |
|| [Netflix DGS] | `367.61` | `163.15` | `2.90x` |
|| [Apollo GraphQL] | `267.91` | `366.35` | `2.11x` |
|| [Hasura] | `126.71` | `554.13` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,972.50` | `1.72` | `70.42x` |
|| [async-graphql] | `9,550.01` | `10.69` | `11.60x` |
|| [Caliban] | `9,469.69` | `10.93` | `11.50x` |
|| [Gqlgen] | `2,205.03` | `46.99` | `2.68x` |
|| [Apollo GraphQL] | `1,748.23` | `57.15` | `2.12x` |
|| [Netflix DGS] | `1,611.97` | `69.72` | `1.96x` |
|| [GraphQL JIT] | `1,355.01` | `73.74` | `1.65x` |
|| [Hasura] | `823.21` | `121.19` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,574.80` | `1.20` | `25.96x` |
|| [Tailcall] | `59,461.20` | `1.70` | `23.19x` |
|| [async-graphql] | `48,263.20` | `2.09` | `18.82x` |
|| [Gqlgen] | `48,012.80` | `5.08` | `18.72x` |
|| [Netflix DGS] | `8,284.47` | `14.53` | `3.23x` |
|| [Apollo GraphQL] | `7,997.92` | `12.70` | `3.12x` |
|| [GraphQL JIT] | `5,187.02` | `19.25` | `2.02x` |
|| [Hasura] | `2,564.63` | `38.97` | `1.00x` |

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
