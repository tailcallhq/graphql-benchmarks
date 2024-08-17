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
|| [Tailcall] | `29,982.80` | `3.31` | `134.86x` |
|| [async-graphql] | `2,033.77` | `49.37` | `9.15x` |
|| [Caliban] | `1,705.05` | `58.66` | `7.67x` |
|| [GraphQL JIT] | `1,363.54` | `73.05` | `6.13x` |
|| [Gqlgen] | `797.59` | `124.40` | `3.59x` |
|| [Netflix DGS] | `371.67` | `162.71` | `1.67x` |
|| [Apollo GraphQL] | `272.75` | `360.56` | `1.23x` |
|| [Hasura] | `222.33` | `446.85` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,213.40` | `1.68` | `86.05x` |
|| [async-graphql] | `10,469.60` | `9.70` | `15.22x` |
|| [Caliban] | `9,856.12` | `10.49` | `14.32x` |
|| [Gqlgen] | `2,212.47` | `46.68` | `3.22x` |
|| [Apollo GraphQL] | `1,780.46` | `56.09` | `2.59x` |
|| [Netflix DGS] | `1,614.11` | `69.65` | `2.35x` |
|| [GraphQL JIT] | `1,390.53` | `71.82` | `2.02x` |
|| [Hasura] | `688.10` | `147.02` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,031.20` | `1.11` | `27.93x` |
|| [Tailcall] | `59,834.00` | `1.68` | `24.94x` |
|| [Gqlgen] | `47,872.40` | `5.17` | `19.95x` |
|| [async-graphql] | `47,208.20` | `2.12` | `19.67x` |
|| [Netflix DGS] | `8,275.82` | `14.95` | `3.45x` |
|| [Apollo GraphQL] | `8,069.56` | `12.55` | `3.36x` |
|| [GraphQL JIT] | `5,249.12` | `19.02` | `2.19x` |
|| [Hasura] | `2,399.55` | `41.77` | `1.00x` |

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
