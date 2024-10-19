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
|| [Tailcall] | `7,771.65` | `12.84` | `66.64x` |
|| [GraphQL JIT] | `1,131.65` | `87.87` | `9.70x` |
|| [async-graphql] | `1,008.35` | `98.35` | `8.65x` |
|| [Caliban] | `763.15` | `131.11` | `6.54x` |
|| [Gqlgen] | `390.93` | `252.18` | `3.35x` |
|| [Netflix DGS] | `191.18` | `505.78` | `1.64x` |
|| [Apollo GraphQL] | `128.62` | `710.65` | `1.10x` |
|| [Hasura] | `116.62` | `766.43` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `15,062.10` | `6.64` | `32.88x` |
|| [async-graphql] | `5,261.43` | `19.09` | `11.48x` |
|| [Caliban] | `4,866.56` | `21.01` | `10.62x` |
|| [GraphQL JIT] | `1,157.85` | `86.19` | `2.53x` |
|| [Gqlgen] | `1,121.23` | `97.81` | `2.45x` |
|| [Apollo GraphQL] | `889.04` | `112.91` | `1.94x` |
|| [Netflix DGS] | `812.27` | `124.73` | `1.77x` |
|| [Hasura] | `458.13` | `227.99` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,287.40` | `3.00` | `22.62x` |
|| [Gqlgen] | `24,556.00` | `8.98` | `16.69x` |
|| [async-graphql] | `23,578.60` | `4.26` | `16.02x` |
|| [Tailcall] | `20,165.30` | `4.98` | `13.70x` |
|| [GraphQL JIT] | `4,619.94` | `21.60` | `3.14x` |
|| [Netflix DGS] | `4,207.42` | `28.23` | `2.86x` |
|| [Apollo GraphQL] | `4,049.08` | `27.19` | `2.75x` |
|| [Hasura] | `1,471.39` | `67.95` | `1.00x` |

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
