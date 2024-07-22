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
|| [Tailcall] | `29,267.60` | `3.40` | `267.10x` |
|| [async-graphql] | `1,740.18` | `57.69` | `15.88x` |
|| [Caliban] | `1,569.42` | `63.36` | `14.32x` |
|| [GraphQL JIT] | `1,336.41` | `74.51` | `12.20x` |
|| [Gqlgen] | `747.49` | `132.68` | `6.82x` |
|| [Netflix DGS] | `352.99` | `194.51` | `3.22x` |
|| [Apollo GraphQL] | `266.96` | `368.47` | `2.44x` |
|| [Hasura] | `109.58` | `549.59` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,892.60` | `1.69` | `67.80x` |
|| [Caliban] | `9,095.25` | `11.36` | `10.47x` |
|| [async-graphql] | `9,013.56` | `11.22` | `10.38x` |
|| [Gqlgen] | `2,150.46` | `48.27` | `2.48x` |
|| [Apollo GraphQL] | `1,790.51` | `55.78` | `2.06x` |
|| [Netflix DGS] | `1,577.33` | `70.02` | `1.82x` |
|| [GraphQL JIT] | `1,355.90` | `73.65` | `1.56x` |
|| [Hasura] | `868.64` | `114.88` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,030.40` | `1.08` | `25.98x` |
|| [Tailcall] | `58,359.30` | `1.73` | `22.61x` |
|| [async-graphql] | `47,894.60` | `2.12` | `18.56x` |
|| [Gqlgen] | `47,153.70` | `5.18` | `18.27x` |
|| [Netflix DGS] | `8,188.33` | `15.04` | `3.17x` |
|| [Apollo GraphQL] | `8,021.30` | `12.65` | `3.11x` |
|| [GraphQL JIT] | `5,168.90` | `19.32` | `2.00x` |
|| [Hasura] | `2,580.56` | `38.79` | `1.00x` |

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
