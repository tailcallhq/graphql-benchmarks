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
|| [Tailcall] | `27,399.00` | `3.63` | `268.18x` |
|| [async-graphql] | `2,039.59` | `51.00` | `19.96x` |
|| [Caliban] | `1,637.05` | `60.95` | `16.02x` |
|| [GraphQL JIT] | `1,313.76` | `75.80` | `12.86x` |
|| [Gqlgen] | `775.26` | `128.10` | `7.59x` |
|| [Netflix DGS] | `360.64` | `170.53` | `3.53x` |
|| [Apollo GraphQL] | `261.11` | `375.16` | `2.56x` |
|| [Hasura] | `102.17` | `512.72` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,325.60` | `1.74` | `66.35x` |
|| [async-graphql] | `9,879.54` | `10.14` | `11.44x` |
|| [Caliban] | `9,476.96` | `10.93` | `10.97x` |
|| [Gqlgen] | `2,184.57` | `47.54` | `2.53x` |
|| [Apollo GraphQL] | `1,720.34` | `58.03` | `1.99x` |
|| [Netflix DGS] | `1,589.78` | `70.81` | `1.84x` |
|| [GraphQL JIT] | `1,393.81` | `71.65` | `1.61x` |
|| [Hasura] | `863.93` | `115.54` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,761.30` | `1.12` | `26.50x` |
|| [Tailcall] | `59,125.40` | `1.70` | `23.13x` |
|| [async-graphql] | `48,470.00` | `2.25` | `18.96x` |
|| [Gqlgen] | `47,591.80` | `5.19` | `18.61x` |
|| [Netflix DGS] | `8,188.34` | `14.79` | `3.20x` |
|| [Apollo GraphQL] | `7,975.62` | `12.68` | `3.12x` |
|| [GraphQL JIT] | `5,167.56` | `19.32` | `2.02x` |
|| [Hasura] | `2,556.76` | `39.02` | `1.00x` |

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
