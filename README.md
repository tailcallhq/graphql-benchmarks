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
|| [Tailcall] | `21,492.90` | `4.64` | `184.19x` |
|| [GraphQL JIT] | `1,138.23` | `87.33` | `9.75x` |
|| [async-graphql] | `974.81` | `101.84` | `8.35x` |
|| [Caliban] | `807.95` | `123.84` | `6.92x` |
|| [Gqlgen] | `377.92` | `260.87` | `3.24x` |
|| [Netflix DGS] | `185.95` | `520.42` | `1.59x` |
|| [Apollo GraphQL] | `131.97` | `698.59` | `1.13x` |
|| [Hasura] | `116.69` | `783.23` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,235.50` | `3.00` | `77.10x` |
|| [async-graphql] | `5,036.37` | `19.92` | `11.68x` |
|| [Caliban] | `4,783.35` | `21.39` | `11.10x` |
|| [GraphQL JIT] | `1,146.73` | `87.05` | `2.66x` |
|| [Gqlgen] | `1,087.78` | `100.60` | `2.52x` |
|| [Apollo GraphQL] | `896.79` | `111.91` | `2.08x` |
|| [Netflix DGS] | `801.98` | `125.91` | `1.86x` |
|| [Hasura] | `431.07` | `235.83` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,103.70` | `2.56` | `27.25x` |
|| [Caliban] | `32,745.30` | `3.06` | `22.82x` |
|| [async-graphql] | `23,591.10` | `4.27` | `16.44x` |
|| [Gqlgen] | `23,446.80` | `9.81` | `16.34x` |
|| [GraphQL JIT] | `4,590.09` | `21.74` | `3.20x` |
|| [Netflix DGS] | `4,141.41` | `28.40` | `2.89x` |
|| [Apollo GraphQL] | `4,043.27` | `27.87` | `2.82x` |
|| [Hasura] | `1,435.21` | `72.85` | `1.00x` |

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
