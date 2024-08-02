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
|| [Tailcall] | `29,893.40` | `3.33` | `200.48x` |
|| [async-graphql] | `1,979.02` | `50.73` | `13.27x` |
|| [Caliban] | `1,694.14` | `58.76` | `11.36x` |
|| [GraphQL JIT] | `1,307.92` | `76.13` | `8.77x` |
|| [Gqlgen] | `786.15` | `126.19` | `5.27x` |
|| [Netflix DGS] | `369.34` | `186.29` | `2.48x` |
|| [Apollo GraphQL] | `265.17` | `370.38` | `1.78x` |
|| [Hasura] | `149.11` | `492.55` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,676.30` | `1.69` | `67.64x` |
|| [async-graphql] | `9,786.87` | `10.37` | `11.28x` |
|| [Caliban] | `9,655.26` | `10.70` | `11.13x` |
|| [Gqlgen] | `2,187.17` | `47.30` | `2.52x` |
|| [Apollo GraphQL] | `1,732.49` | `57.67` | `2.00x` |
|| [Netflix DGS] | `1,609.35` | `69.48` | `1.86x` |
|| [GraphQL JIT] | `1,473.54` | `67.78` | `1.70x` |
|| [Hasura] | `867.48` | `115.02` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,421.40` | `1.08` | `25.51x` |
|| [Tailcall] | `59,795.80` | `1.69` | `21.97x` |
|| [async-graphql] | `47,676.40` | `2.16` | `17.52x` |
|| [Gqlgen] | `46,812.00` | `5.26` | `17.20x` |
|| [Netflix DGS] | `8,354.44` | `14.57` | `3.07x` |
|| [Apollo GraphQL] | `7,934.59` | `12.87` | `2.92x` |
|| [GraphQL JIT] | `5,596.84` | `17.84` | `2.06x` |
|| [Hasura] | `2,721.48` | `36.83` | `1.00x` |

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
