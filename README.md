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
|| [Tailcall] | `21,010.60` | `4.75` | `176.88x` |
|| [GraphQL JIT] | `1,160.88` | `85.62` | `9.77x` |
|| [async-graphql] | `963.82` | `103.00` | `8.11x` |
|| [Caliban] | `756.51` | `132.50` | `6.37x` |
|| [Gqlgen] | `380.38` | `259.20` | `3.20x` |
|| [Netflix DGS] | `191.50` | `506.21` | `1.61x` |
|| [Apollo GraphQL] | `134.45` | `687.84` | `1.13x` |
|| [Hasura] | `118.78` | `794.72` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,059.80` | `3.02` | `70.75x` |
|| [async-graphql] | `4,991.39` | `20.05` | `10.68x` |
|| [Caliban] | `4,951.10` | `20.63` | `10.60x` |
|| [GraphQL JIT] | `1,200.34` | `83.13` | `2.57x` |
|| [Gqlgen] | `1,072.84` | `102.35` | `2.30x` |
|| [Apollo GraphQL] | `917.33` | `109.27` | `1.96x` |
|| [Netflix DGS] | `813.59` | `123.61` | `1.74x` |
|| [Hasura] | `467.28` | `216.98` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,969.00` | `2.57` | `25.63x` |
|| [Caliban] | `33,675.10` | `2.99` | `22.15x` |
|| [async-graphql] | `23,293.30` | `4.30` | `15.32x` |
|| [Gqlgen] | `23,157.70` | `9.57` | `15.23x` |
|| [GraphQL JIT] | `4,706.94` | `21.20` | `3.10x` |
|| [Netflix DGS] | `4,197.17` | `28.60` | `2.76x` |
|| [Apollo GraphQL] | `4,151.06` | `27.01` | `2.73x` |
|| [Hasura] | `1,520.66` | `65.83` | `1.00x` |

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
