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
|| [Tailcall] | `30,480.10` | `3.27` | `111.20x` |
|| [async-graphql] | `1,916.59` | `52.16` | `6.99x` |
|| [Caliban] | `1,587.56` | `62.67` | `5.79x` |
|| [Hasura] | `1,523.21` | `65.39` | `5.56x` |
|| [GraphQL JIT] | `1,386.70` | `71.81` | `5.06x` |
|| [Gqlgen] | `783.75` | `126.61` | `2.86x` |
|| [Netflix DGS] | `363.33` | `159.65` | `1.33x` |
|| [Apollo GraphQL] | `274.11` | `357.84` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,137.80` | `1.60` | `43.49x` |
|| [async-graphql] | `9,579.56` | `10.50` | `6.70x` |
|| [Caliban] | `9,134.96` | `11.30` | `6.39x` |
|| [Hasura] | `2,543.68` | `39.28` | `1.78x` |
|| [Gqlgen] | `2,204.83` | `46.91` | `1.54x` |
|| [Apollo GraphQL] | `1,790.03` | `55.79` | `1.25x` |
|| [Netflix DGS] | `1,590.70` | `69.50` | `1.11x` |
|| [GraphQL JIT] | `1,428.74` | `69.89` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,697.90` | `1.09` | `25.77x` |
|| [Tailcall] | `64,184.40` | `1.57` | `24.43x` |
|| [async-graphql] | `51,958.50` | `2.01` | `19.78x` |
|| [Gqlgen] | `48,314.80` | `5.06` | `18.39x` |
|| [Netflix DGS] | `8,277.89` | `14.30` | `3.15x` |
|| [Apollo GraphQL] | `8,219.81` | `12.39` | `3.13x` |
|| [GraphQL JIT] | `5,321.57` | `18.76` | `2.03x` |
|| [Hasura] | `2,627.25` | `38.00` | `1.00x` |

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
