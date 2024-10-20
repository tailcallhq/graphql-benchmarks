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
|| [Tailcall] | `8,354.97` | `11.98` | `73.87x` |
|| [GraphQL JIT] | `1,119.84` | `88.80` | `9.90x` |
|| [async-graphql] | `972.01` | `102.17` | `8.59x` |
|| [Caliban] | `790.62` | `126.63` | `6.99x` |
|| [Gqlgen] | `400.25` | `246.35` | `3.54x` |
|| [Netflix DGS] | `189.21` | `510.09` | `1.67x` |
|| [Apollo GraphQL] | `126.66` | `715.65` | `1.12x` |
|| [Hasura] | `113.10` | `788.99` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,170.70` | `6.18` | `35.94x` |
|| [async-graphql] | `5,134.43` | `19.52` | `11.41x` |
|| [Caliban] | `4,813.15` | `21.28` | `10.70x` |
|| [GraphQL JIT] | `1,168.67` | `85.41` | `2.60x` |
|| [Gqlgen] | `1,134.34` | `96.36` | `2.52x` |
|| [Apollo GraphQL] | `898.76` | `111.74` | `2.00x` |
|| [Netflix DGS] | `814.20` | `124.33` | `1.81x` |
|| [Hasura] | `449.97` | `226.68` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,341.30` | `3.04` | `21.69x` |
|| [Gqlgen] | `24,549.60` | `9.36` | `15.97x` |
|| [async-graphql] | `23,454.80` | `4.28` | `15.26x` |
|| [Tailcall] | `20,803.60` | `4.82` | `13.53x` |
|| [GraphQL JIT] | `4,625.43` | `21.57` | `3.01x` |
|| [Netflix DGS] | `4,194.32` | `28.79` | `2.73x` |
|| [Apollo GraphQL] | `4,042.60` | `27.90` | `2.63x` |
|| [Hasura] | `1,537.08` | `66.68` | `1.00x` |

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
