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
|| [Tailcall] | `18,412.70` | `5.42` | `157.07x` |
|| [GraphQL JIT] | `1,131.26` | `87.87` | `9.65x` |
|| [async-graphql] | `1,021.57` | `97.14` | `8.71x` |
|| [Caliban] | `714.49` | `139.73` | `6.10x` |
|| [Gqlgen] | `389.03` | `253.56` | `3.32x` |
|| [Netflix DGS] | `186.48` | `522.92` | `1.59x` |
|| [Apollo GraphQL] | `123.81` | `729.74` | `1.06x` |
|| [Hasura] | `117.22` | `699.71` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `30,776.40` | `3.25` | `73.93x` |
|| [async-graphql] | `5,257.90` | `19.04` | `12.63x` |
|| [Caliban] | `4,745.34` | `21.49` | `11.40x` |
|| [GraphQL JIT] | `1,168.31` | `85.43` | `2.81x` |
|| [Gqlgen] | `1,105.02` | `99.79` | `2.65x` |
|| [Apollo GraphQL] | `834.15` | `120.38` | `2.00x` |
|| [Netflix DGS] | `791.83` | `126.91` | `1.90x` |
|| [Hasura] | `416.29` | `242.36` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `37,565.40` | `2.67` | `25.12x` |
|| [Gqlgen] | `24,856.60` | `9.70` | `16.62x` |
|| [Tailcall] | `24,435.10` | `4.10` | `16.34x` |
|| [async-graphql] | `23,374.20` | `4.32` | `15.63x` |
|| [GraphQL JIT] | `4,645.39` | `21.48` | `3.11x` |
|| [Netflix DGS] | `4,164.43` | `28.72` | `2.79x` |
|| [Apollo GraphQL] | `3,898.01` | `29.23` | `2.61x` |
|| [Hasura] | `1,495.24` | `72.90` | `1.00x` |

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
