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
|| [Tailcall] | `21,409.40` | `4.66` | `185.57x` |
|| [GraphQL JIT] | `1,132.78` | `87.77` | `9.82x` |
|| [async-graphql] | `1,003.58` | `98.96` | `8.70x` |
|| [Caliban] | `773.86` | `129.70` | `6.71x` |
|| [Gqlgen] | `393.03` | `250.74` | `3.41x` |
|| [Netflix DGS] | `189.62` | `506.68` | `1.64x` |
|| [Apollo GraphQL] | `132.06` | `697.96` | `1.14x` |
|| [Hasura] | `115.37` | `803.04` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,755.00` | `3.05` | `80.32x` |
|| [async-graphql] | `5,182.96` | `19.33` | `12.71x` |
|| [Caliban] | `4,870.13` | `21.09` | `11.94x` |
|| [GraphQL JIT] | `1,176.95` | `84.80` | `2.89x` |
|| [Gqlgen] | `1,112.89` | `98.25` | `2.73x` |
|| [Apollo GraphQL] | `891.15` | `112.80` | `2.19x` |
|| [Netflix DGS] | `813.14` | `123.61` | `1.99x` |
|| [Hasura] | `407.81` | `251.09` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,171.20` | `2.55` | `25.95x` |
|| [Caliban] | `33,190.60` | `3.02` | `21.99x` |
|| [Gqlgen] | `24,575.50` | `8.83` | `16.28x` |
|| [async-graphql] | `24,072.20` | `4.17` | `15.95x` |
|| [GraphQL JIT] | `4,699.96` | `21.23` | `3.11x` |
|| [Netflix DGS] | `4,204.63` | `28.35` | `2.79x` |
|| [Apollo GraphQL] | `4,119.85` | `27.13` | `2.73x` |
|| [Hasura] | `1,509.35` | `67.33` | `1.00x` |

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
