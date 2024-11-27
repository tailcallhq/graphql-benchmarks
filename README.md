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
|| [Tailcall] | `21,833.50` | `4.57` | `186.79x` |
|| [GraphQL JIT] | `1,089.43` | `91.25` | `9.32x` |
|| [async-graphql] | `1,006.43` | `98.70` | `8.61x` |
|| [Caliban] | `802.15` | `124.60` | `6.86x` |
|| [Gqlgen] | `374.32` | `263.23` | `3.20x` |
|| [Netflix DGS] | `187.63` | `513.47` | `1.61x` |
|| [Apollo GraphQL] | `125.71` | `724.34` | `1.08x` |
|| [Hasura] | `116.89` | `736.58` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,918.60` | `3.04` | `77.51x` |
|| [async-graphql] | `5,159.52` | `19.70` | `12.15x` |
|| [Caliban] | `4,894.63` | `20.91` | `11.53x` |
|| [GraphQL JIT] | `1,109.37` | `89.95` | `2.61x` |
|| [Gqlgen] | `1,093.13` | `100.96` | `2.57x` |
|| [Apollo GraphQL] | `868.20` | `115.64` | `2.04x` |
|| [Netflix DGS] | `801.39` | `125.42` | `1.89x` |
|| [Hasura] | `424.68` | `249.09` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,763.80` | `2.52` | `26.28x` |
|| [Caliban] | `32,767.50` | `3.05` | `21.65x` |
|| [async-graphql] | `24,198.50` | `4.13` | `15.99x` |
|| [Gqlgen] | `24,071.60` | `8.87` | `15.91x` |
|| [GraphQL JIT] | `4,461.85` | `22.35` | `2.95x` |
|| [Netflix DGS] | `4,119.28` | `28.78` | `2.72x` |
|| [Apollo GraphQL] | `3,914.85` | `28.48` | `2.59x` |
|| [Hasura] | `1,513.34` | `66.59` | `1.00x` |

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
