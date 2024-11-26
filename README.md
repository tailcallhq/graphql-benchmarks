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
|| [Tailcall] | `22,014.60` | `4.53` | `186.46x` |
|| [GraphQL JIT] | `1,117.42` | `89.04` | `9.46x` |
|| [async-graphql] | `959.94` | `103.33` | `8.13x` |
|| [Caliban] | `809.91` | `123.63` | `6.86x` |
|| [Gqlgen] | `371.40` | `265.31` | `3.15x` |
|| [Netflix DGS] | `184.02` | `523.94` | `1.56x` |
|| [Apollo GraphQL] | `130.12` | `705.56` | `1.10x` |
|| [Hasura] | `118.06` | `781.95` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,352.60` | `3.00` | `70.26x` |
|| [async-graphql] | `5,096.01` | `19.67` | `10.74x` |
|| [Caliban] | `4,978.06` | `20.56` | `10.49x` |
|| [GraphQL JIT] | `1,191.85` | `83.74` | `2.51x` |
|| [Gqlgen] | `1,092.16` | `100.02` | `2.30x` |
|| [Apollo GraphQL] | `885.60` | `113.28` | `1.87x` |
|| [Netflix DGS] | `805.73` | `124.37` | `1.70x` |
|| [Hasura] | `474.69` | `217.56` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,443.30` | `2.54` | `24.72x` |
|| [Caliban] | `33,070.60` | `3.03` | `20.72x` |
|| [Gqlgen] | `24,613.40` | `9.16` | `15.42x` |
|| [async-graphql] | `23,850.50` | `4.20` | `14.95x` |
|| [GraphQL JIT] | `4,686.12` | `21.30` | `2.94x` |
|| [Netflix DGS] | `4,155.11` | `28.77` | `2.60x` |
|| [Apollo GraphQL] | `3,982.33` | `27.41` | `2.50x` |
|| [Hasura] | `1,595.79` | `62.51` | `1.00x` |

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
