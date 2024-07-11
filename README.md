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
|| [Tailcall] | `29,825.30` | `3.34` | `115.12x` |
|| [async-graphql] | `1,855.36` | `53.92` | `7.16x` |
|| [Caliban] | `1,551.47` | `64.13` | `5.99x` |
|| [Hasura] | `1,482.73` | `67.18` | `5.72x` |
|| [GraphQL JIT] | `1,290.72` | `77.13` | `4.98x` |
|| [Gqlgen] | `762.45` | `130.08` | `2.94x` |
|| [Netflix DGS] | `357.98` | `223.33` | `1.38x` |
|| [Apollo GraphQL] | `259.08` | `379.35` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,621.30` | `1.62` | `46.04x` |
|| [async-graphql] | `9,406.04` | `10.75` | `7.03x` |
|| [Caliban] | `9,281.22` | `11.13` | `6.93x` |
|| [Hasura] | `2,441.14` | `40.93` | `1.82x` |
|| [Gqlgen] | `2,134.66` | `48.40` | `1.59x` |
|| [Apollo GraphQL] | `1,717.14` | `58.15` | `1.28x` |
|| [Netflix DGS] | `1,576.02` | `69.28` | `1.18x` |
|| [GraphQL JIT] | `1,338.42` | `74.60` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,438.00` | `1.01` | `27.70x` |
|| [Tailcall] | `64,086.80` | `1.57` | `25.57x` |
|| [async-graphql] | `50,234.90` | `2.00` | `20.04x` |
|| [Gqlgen] | `46,663.50` | `5.17` | `18.62x` |
|| [Netflix DGS] | `8,154.77` | `15.52` | `3.25x` |
|| [Apollo GraphQL] | `7,873.54` | `12.95` | `3.14x` |
|| [GraphQL JIT] | `5,020.40` | `19.91` | `2.00x` |
|| [Hasura] | `2,506.68` | `39.80` | `1.00x` |

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
