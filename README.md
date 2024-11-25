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
|| [Tailcall] | `20,923.30` | `4.77` | `169.91x` |
|| [GraphQL JIT] | `1,151.18` | `86.36` | `9.35x` |
|| [async-graphql] | `986.30` | `100.70` | `8.01x` |
|| [Caliban] | `743.84` | `134.83` | `6.04x` |
|| [Gqlgen] | `389.93` | `252.69` | `3.17x` |
|| [Netflix DGS] | `187.54` | `514.43` | `1.52x` |
|| [Apollo GraphQL] | `129.99` | `702.28` | `1.06x` |
|| [Hasura] | `123.14` | `733.74` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,730.80` | `3.05` | `76.60x` |
|| [async-graphql] | `5,116.67` | `19.59` | `11.97x` |
|| [Caliban] | `4,666.05` | `21.97` | `10.92x` |
|| [GraphQL JIT] | `1,180.68` | `84.53` | `2.76x` |
|| [Gqlgen] | `1,050.21` | `104.47` | `2.46x` |
|| [Apollo GraphQL] | `855.42` | `117.43` | `2.00x` |
|| [Netflix DGS] | `805.43` | `124.89` | `1.89x` |
|| [Hasura] | `427.28` | `243.98` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,258.40` | `2.55` | `25.13x` |
|| [Caliban] | `33,429.00` | `3.00` | `21.40x` |
|| [Gqlgen] | `24,181.60` | `8.56` | `15.48x` |
|| [async-graphql] | `23,337.00` | `4.30` | `14.94x` |
|| [GraphQL JIT] | `4,676.77` | `21.33` | `2.99x` |
|| [Netflix DGS] | `4,166.64` | `28.25` | `2.67x` |
|| [Apollo GraphQL] | `3,846.94` | `29.29` | `2.46x` |
|| [Hasura] | `1,562.16` | `64.97` | `1.00x` |

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
