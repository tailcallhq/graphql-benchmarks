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
|| [Tailcall] | `17,959.30` | `5.55` | `149.54x` |
|| [GraphQL JIT] | `1,139.28` | `87.25` | `9.49x` |
|| [async-graphql] | `1,006.87` | `98.64` | `8.38x` |
|| [Caliban] | `721.86` | `138.55` | `6.01x` |
|| [Gqlgen] | `393.88` | `250.32` | `3.28x` |
|| [Netflix DGS] | `189.72` | `508.60` | `1.58x` |
|| [Apollo GraphQL] | `129.79` | `704.45` | `1.08x` |
|| [Hasura] | `120.10` | `707.89` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,670.70` | `3.26` | `71.97x` |
|| [async-graphql] | `5,220.25` | `19.15` | `12.25x` |
|| [Caliban] | `4,933.28` | `20.71` | `11.58x` |
|| [GraphQL JIT] | `1,170.60` | `85.27` | `2.75x` |
|| [Gqlgen] | `1,106.64` | `99.27` | `2.60x` |
|| [Apollo GraphQL] | `884.55` | `113.41` | `2.08x` |
|| [Netflix DGS] | `807.11` | `124.43` | `1.89x` |
|| [Hasura] | `426.14` | `239.43` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `39,454.50` | `2.54` | `25.77x` |
|| [Gqlgen] | `24,667.20` | `12.33` | `16.11x` |
|| [Tailcall] | `24,281.10` | `4.12` | `15.86x` |
|| [async-graphql] | `23,633.50` | `4.24` | `15.44x` |
|| [GraphQL JIT] | `4,608.92` | `21.64` | `3.01x` |
|| [Netflix DGS] | `4,165.49` | `28.98` | `2.72x` |
|| [Apollo GraphQL] | `3,985.42` | `28.19` | `2.60x` |
|| [Hasura] | `1,530.76` | `65.35` | `1.00x` |

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
