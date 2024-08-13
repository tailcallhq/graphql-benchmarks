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
|| [Tailcall] | `28,947.80` | `3.44` | `212.86x` |
|| [async-graphql] | `2,031.59` | `49.17` | `14.94x` |
|| [Caliban] | `1,806.84` | `55.03` | `13.29x` |
|| [GraphQL JIT] | `1,329.46` | `74.89` | `9.78x` |
|| [Gqlgen] | `788.72` | `125.80` | `5.80x` |
|| [Netflix DGS] | `364.57` | `225.73` | `2.68x` |
|| [Apollo GraphQL] | `268.48` | `365.52` | `1.97x` |
|| [Hasura] | `135.99` | `529.26` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,268.40` | `1.71` | `69.06x` |
|| [async-graphql] | `10,333.20` | `9.78` | `12.25x` |
|| [Caliban] | `9,914.25` | `10.42` | `11.75x` |
|| [Gqlgen] | `2,145.37` | `48.17` | `2.54x` |
|| [Apollo GraphQL] | `1,779.01` | `56.13` | `2.11x` |
|| [Netflix DGS] | `1,598.59` | `69.94` | `1.89x` |
|| [GraphQL JIT] | `1,398.09` | `71.43` | `1.66x` |
|| [Hasura] | `843.75` | `118.28` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,169.90` | `1.03` | `27.04x` |
|| [Tailcall] | `59,057.10` | `1.71` | `23.78x` |
|| [async-graphql] | `47,968.10` | `2.15` | `19.31x` |
|| [Gqlgen] | `47,560.90` | `5.21` | `19.15x` |
|| [Netflix DGS] | `8,298.82` | `14.37` | `3.34x` |
|| [Apollo GraphQL] | `8,113.91` | `12.49` | `3.27x` |
|| [GraphQL JIT] | `5,177.47` | `19.28` | `2.08x` |
|| [Hasura] | `2,483.77` | `40.16` | `1.00x` |

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
