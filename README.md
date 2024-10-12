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
|| [Tailcall] | `13,797.20` | `7.24` | `114.12x` |
|| [GraphQL JIT] | `1,125.19` | `88.39` | `9.31x` |
|| [async-graphql] | `1,021.75` | `97.22` | `8.45x` |
|| [Caliban] | `750.28` | `133.90` | `6.21x` |
|| [Gqlgen] | `379.47` | `259.70` | `3.14x` |
|| [Netflix DGS] | `183.91` | `525.13` | `1.52x` |
|| [Apollo GraphQL] | `133.77` | `689.16` | `1.11x` |
|| [Hasura] | `120.90` | `728.98` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,015.00` | `4.76` | `48.61x` |
|| [async-graphql] | `5,337.32` | `18.76` | `12.35x` |
|| [Caliban] | `4,824.71` | `21.20` | `11.16x` |
|| [GraphQL JIT] | `1,165.04` | `85.68` | `2.69x` |
|| [Gqlgen] | `1,094.60` | `100.25` | `2.53x` |
|| [Apollo GraphQL] | `900.54` | `111.37` | `2.08x` |
|| [Netflix DGS] | `797.04` | `126.28` | `1.84x` |
|| [Hasura] | `432.34` | `234.67` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,296.00` | `3.11` | `21.76x` |
|| [async-graphql] | `24,278.10` | `4.16` | `16.35x` |
|| [Gqlgen] | `24,086.00` | `10.12` | `16.23x` |
|| [Tailcall] | `20,500.40` | `4.90` | `13.81x` |
|| [GraphQL JIT] | `4,606.70` | `21.65` | `3.10x` |
|| [Netflix DGS] | `4,187.20` | `28.27` | `2.82x` |
|| [Apollo GraphQL] | `3,957.62` | `27.81` | `2.67x` |
|| [Hasura] | `1,484.48` | `67.21` | `1.00x` |

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
