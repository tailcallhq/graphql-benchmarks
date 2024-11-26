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
|| [Tailcall] | `21,547.30` | `4.63` | `181.24x` |
|| [GraphQL JIT] | `1,135.30` | `87.55` | `9.55x` |
|| [async-graphql] | `996.65` | `99.59` | `8.38x` |
|| [Caliban] | `764.81` | `130.90` | `6.43x` |
|| [Gqlgen] | `371.13` | `265.83` | `3.12x` |
|| [Netflix DGS] | `188.23` | `513.05` | `1.58x` |
|| [Apollo GraphQL] | `120.61` | `750.59` | `1.01x` |
|| [Hasura] | `118.89` | `735.72` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,608.90` | `3.06` | `71.65x` |
|| [async-graphql] | `5,097.12` | `19.65` | `11.20x` |
|| [Caliban] | `4,803.46` | `21.41` | `10.55x` |
|| [GraphQL JIT] | `1,168.86` | `85.38` | `2.57x` |
|| [Gqlgen] | `1,099.00` | `99.90` | `2.41x` |
|| [Netflix DGS] | `807.38` | `124.75` | `1.77x` |
|| [Apollo GraphQL] | `802.92` | `125.17` | `1.76x` |
|| [Hasura] | `455.12` | `223.27` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,414.50` | `2.55` | `26.05x` |
|| [Caliban] | `33,007.80` | `3.05` | `21.82x` |
|| [Gqlgen] | `24,437.20` | `8.88` | `16.15x` |
|| [async-graphql] | `23,747.50` | `4.26` | `15.70x` |
|| [GraphQL JIT] | `4,738.52` | `21.06` | `3.13x` |
|| [Netflix DGS] | `4,164.51` | `28.41` | `2.75x` |
|| [Apollo GraphQL] | `3,816.95` | `28.92` | `2.52x` |
|| [Hasura] | `1,512.87` | `66.04` | `1.00x` |

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
