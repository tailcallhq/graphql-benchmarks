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
|| [Tailcall] | `21,364.60` | `4.67` | `183.62x` |
|| [GraphQL JIT] | `1,142.25` | `87.00` | `9.82x` |
|| [async-graphql] | `989.08` | `100.33` | `8.50x` |
|| [Caliban] | `747.53` | `134.77` | `6.42x` |
|| [Gqlgen] | `366.82` | `268.67` | `3.15x` |
|| [Netflix DGS] | `189.82` | `508.84` | `1.63x` |
|| [Apollo GraphQL] | `126.46` | `719.62` | `1.09x` |
|| [Hasura] | `116.35` | `770.61` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,864.60` | `3.04` | `74.53x` |
|| [async-graphql] | `5,165.13` | `19.41` | `11.71x` |
|| [Caliban] | `4,745.89` | `21.54` | `10.76x` |
|| [GraphQL JIT] | `1,181.68` | `84.46` | `2.68x` |
|| [Gqlgen] | `1,062.44` | `103.18` | `2.41x` |
|| [Apollo GraphQL] | `855.39` | `117.31` | `1.94x` |
|| [Netflix DGS] | `803.94` | `125.12` | `1.82x` |
|| [Hasura] | `440.94` | `265.58` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,606.70` | `2.53` | `26.25x` |
|| [Caliban] | `33,392.70` | `3.01` | `22.13x` |
|| [async-graphql] | `23,340.40` | `4.30` | `15.47x` |
|| [Gqlgen] | `22,860.10` | `9.85` | `15.15x` |
|| [GraphQL JIT] | `4,654.74` | `21.44` | `3.09x` |
|| [Netflix DGS] | `4,170.55` | `28.70` | `2.76x` |
|| [Apollo GraphQL] | `3,908.05` | `28.51` | `2.59x` |
|| [Hasura] | `1,508.62` | `67.21` | `1.00x` |

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
