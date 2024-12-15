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
|| [Tailcall] | `20,115.20` | `4.96` | `171.12x` |
|| [GraphQL JIT] | `1,158.49` | `85.87` | `9.86x` |
|| [async-graphql] | `986.61` | `100.56` | `8.39x` |
|| [Caliban] | `690.96` | `145.49` | `5.88x` |
|| [Gqlgen] | `394.44` | `250.06` | `3.36x` |
|| [Netflix DGS] | `189.32` | `512.25` | `1.61x` |
|| [Apollo GraphQL] | `129.43` | `707.88` | `1.10x` |
|| [Hasura] | `117.55` | `780.99` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `31,734.60` | `3.15` | `67.82x` |
|| [async-graphql] | `5,152.40` | `19.47` | `11.01x` |
|| [Caliban] | `4,628.55` | `22.14` | `9.89x` |
|| [GraphQL JIT] | `1,179.93` | `84.59` | `2.52x` |
|| [Gqlgen] | `1,131.10` | `97.04` | `2.42x` |
|| [Apollo GraphQL] | `893.13` | `112.39` | `1.91x` |
|| [Netflix DGS] | `806.56` | `125.48` | `1.72x` |
|| [Hasura] | `467.93` | `253.32` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,576.00` | `2.59` | `24.67x` |
|| [Caliban] | `32,886.70` | `3.06` | `21.03x` |
|| [Gqlgen] | `24,212.30` | `10.54` | `15.48x` |
|| [async-graphql] | `23,659.00` | `4.26` | `15.13x` |
|| [GraphQL JIT] | `4,658.98` | `21.40` | `2.98x` |
|| [Netflix DGS] | `4,176.59` | `28.63` | `2.67x` |
|| [Apollo GraphQL] | `4,051.44` | `27.47` | `2.59x` |
|| [Hasura] | `1,563.82` | `65.73` | `1.00x` |

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
