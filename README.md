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
|| [Tailcall] | `20,481.60` | `4.87` | `172.57x` |
|| [GraphQL JIT] | `1,152.33` | `86.24` | `9.71x` |
|| [async-graphql] | `992.68` | `100.02` | `8.36x` |
|| [Caliban] | `736.62` | `136.28` | `6.21x` |
|| [Gqlgen] | `371.39` | `265.08` | `3.13x` |
|| [Netflix DGS] | `188.58` | `513.31` | `1.59x` |
|| [Apollo GraphQL] | `132.09` | `694.43` | `1.11x` |
|| [Hasura] | `118.68` | `715.27` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,361.80` | `3.09` | `69.02x` |
|| [async-graphql] | `5,134.47` | `19.57` | `10.95x` |
|| [Caliban] | `4,755.25` | `21.54` | `10.14x` |
|| [GraphQL JIT] | `1,182.52` | `84.39` | `2.52x` |
|| [Gqlgen] | `1,076.71` | `102.08` | `2.30x` |
|| [Apollo GraphQL] | `906.09` | `110.65` | `1.93x` |
|| [Netflix DGS] | `807.38` | `124.91` | `1.72x` |
|| [Hasura] | `468.90` | `217.88` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,127.30` | `2.49` | `25.83x` |
|| [Caliban] | `33,000.10` | `3.05` | `21.24x` |
|| [async-graphql] | `23,789.50` | `4.24` | `15.31x` |
|| [Gqlgen] | `23,424.10` | `9.21` | `15.08x` |
|| [GraphQL JIT] | `4,633.38` | `21.52` | `2.98x` |
|| [Netflix DGS] | `4,258.01` | `27.74` | `2.74x` |
|| [Apollo GraphQL] | `4,131.14` | `27.57` | `2.66x` |
|| [Hasura] | `1,553.36` | `68.61` | `1.00x` |

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
