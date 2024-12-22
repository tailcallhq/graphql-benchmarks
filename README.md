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
|| [Tailcall] | `21,567.50` | `4.63` | `193.15x` |
|| [GraphQL JIT] | `1,125.80` | `88.22` | `10.08x` |
|| [async-graphql] | `937.59` | `105.80` | `8.40x` |
|| [Caliban] | `719.69` | `139.42` | `6.45x` |
|| [Gqlgen] | `397.66` | `247.94` | `3.56x` |
|| [Netflix DGS] | `189.32` | `513.39` | `1.70x` |
|| [Apollo GraphQL] | `131.98` | `696.28` | `1.18x` |
|| [Hasura] | `111.66` | `766.72` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,146.80` | `3.02` | `82.11x` |
|| [async-graphql] | `4,955.10` | `20.21` | `12.27x` |
|| [Caliban] | `4,831.11` | `21.12` | `11.97x` |
|| [GraphQL JIT] | `1,152.00` | `86.64` | `2.85x` |
|| [Gqlgen] | `1,143.60` | `95.72` | `2.83x` |
|| [Apollo GraphQL] | `904.10` | `110.96` | `2.24x` |
|| [Netflix DGS] | `811.94` | `124.36` | `2.01x` |
|| [Hasura] | `403.71` | `248.87` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,069.10` | `2.56` | `26.65x` |
|| [Caliban] | `32,947.10` | `3.05` | `22.47x` |
|| [Gqlgen] | `24,065.30` | `9.35` | `16.42x` |
|| [async-graphql] | `23,516.00` | `4.26` | `16.04x` |
|| [GraphQL JIT] | `4,631.14` | `21.53` | `3.16x` |
|| [Netflix DGS] | `4,158.73` | `28.93` | `2.84x` |
|| [Apollo GraphQL] | `4,032.95` | `27.78` | `2.75x` |
|| [Hasura] | `1,465.96` | `67.98` | `1.00x` |

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
