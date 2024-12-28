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
|| [Tailcall] | `21,616.20` | `4.61` | `204.32x` |
|| [GraphQL JIT] | `1,134.83` | `87.67` | `10.73x` |
|| [async-graphql] | `961.50` | `103.33` | `9.09x` |
|| [Caliban] | `774.23` | `129.04` | `7.32x` |
|| [Gqlgen] | `394.39` | `250.02` | `3.73x` |
|| [Netflix DGS] | `189.23` | `511.50` | `1.79x` |
|| [Apollo GraphQL] | `133.38` | `688.97` | `1.26x` |
|| [Hasura] | `105.80` | `806.48` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,386.80` | `3.09` | `84.44x` |
|| [async-graphql] | `5,166.50` | `19.39` | `13.47x` |
|| [Caliban] | `4,872.88` | `21.08` | `12.70x` |
|| [GraphQL JIT] | `1,167.91` | `85.45` | `3.05x` |
|| [Gqlgen] | `1,148.64` | `94.93` | `2.99x` |
|| [Apollo GraphQL] | `903.06` | `111.00` | `2.35x` |
|| [Netflix DGS] | `808.37` | `124.38` | `2.11x` |
|| [Hasura] | `383.54` | `259.90` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,812.50` | `2.58` | `27.13x` |
|| [Caliban] | `33,225.20` | `3.02` | `23.22x` |
|| [async-graphql] | `23,790.80` | `4.22` | `16.63x` |
|| [Gqlgen] | `23,565.90` | `9.02` | `16.47x` |
|| [GraphQL JIT] | `4,674.15` | `21.34` | `3.27x` |
|| [Netflix DGS] | `4,236.14` | `28.31` | `2.96x` |
|| [Apollo GraphQL] | `4,094.79` | `26.86` | `2.86x` |
|| [Hasura] | `1,430.68` | `72.55` | `1.00x` |

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
