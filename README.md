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
|| [Tailcall] | `21,738.40` | `4.59` | `213.54x` |
|| [Gqlgen] | `2,241.66` | `44.81` | `22.02x` |
|| [GraphQL JIT] | `1,980.17` | `50.40` | `19.45x` |
|| [async-graphql] | `969.37` | `102.36` | `9.52x` |
|| [Caliban] | `791.73` | `126.54` | `7.78x` |
|| [Netflix DGS] | `189.99` | `512.14` | `1.87x` |
|| [Apollo GraphQL] | `130.61` | `704.04` | `1.28x` |
|| [Hasura] | `101.80` | `785.67` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,085.60` | `3.02` | `84.84x` |
|| [Gqlgen] | `7,141.90` | `15.53` | `18.31x` |
|| [async-graphql] | `5,056.24` | `19.86` | `12.97x` |
|| [Caliban] | `4,871.98` | `21.04` | `12.49x` |
|| [GraphQL JIT] | `2,320.68` | `43.15` | `5.95x` |
|| [Apollo GraphQL] | `885.77` | `113.30` | `2.27x` |
|| [Netflix DGS] | `812.18` | `123.69` | `2.08x` |
|| [Hasura] | `389.99` | `269.73` | `1.00x` |
| 3 | `{ greet }` |
|| [Gqlgen] | `176,293.00` | `777.55` | `133.37x` |
|| [Tailcall] | `39,546.00` | `2.54` | `29.92x` |
|| [Caliban] | `34,233.50` | `2.93` | `25.90x` |
|| [async-graphql] | `23,305.30` | `4.31` | `17.63x` |
|| [GraphQL JIT] | `9,593.71` | `10.42` | `7.26x` |
|| [Netflix DGS] | `4,187.69` | `28.47` | `3.17x` |
|| [Apollo GraphQL] | `3,993.19` | `27.81` | `3.02x` |
|| [Hasura] | `1,321.85` | `75.78` | `1.00x` |

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
