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
|| [Tailcall] | `20,797.00` | `4.80` | `173.80x` |
|| [GraphQL JIT] | `1,138.00` | `87.29` | `9.51x` |
|| [async-graphql] | `984.06` | `100.81` | `8.22x` |
|| [Caliban] | `798.58` | `125.07` | `6.67x` |
|| [Gqlgen] | `385.72` | `255.46` | `3.22x` |
|| [Netflix DGS] | `189.75` | `509.76` | `1.59x` |
|| [Apollo GraphQL] | `131.54` | `698.15` | `1.10x` |
|| [Hasura] | `119.66` | `713.45` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,074.20` | `3.02` | `70.87x` |
|| [async-graphql] | `5,106.52` | `19.60` | `10.94x` |
|| [Caliban] | `4,845.30` | `21.10` | `10.38x` |
|| [GraphQL JIT] | `1,174.92` | `84.94` | `2.52x` |
|| [Gqlgen] | `1,069.96` | `103.10` | `2.29x` |
|| [Apollo GraphQL] | `892.98` | `112.37` | `1.91x` |
|| [Netflix DGS] | `807.10` | `124.54` | `1.73x` |
|| [Hasura] | `466.66` | `216.88` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,141.60` | `2.50` | `28.00x` |
|| [Caliban] | `33,205.70` | `3.04` | `23.16x` |
|| [Gqlgen] | `24,116.00` | `9.07` | `16.82x` |
|| [async-graphql] | `23,699.00` | `4.25` | `16.53x` |
|| [GraphQL JIT] | `4,644.68` | `21.48` | `3.24x` |
|| [Netflix DGS] | `4,178.27` | `28.32` | `2.91x` |
|| [Apollo GraphQL] | `4,049.12` | `26.97` | `2.82x` |
|| [Hasura] | `1,433.47` | `71.47` | `1.00x` |

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
