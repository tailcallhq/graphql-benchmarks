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
|| [Tailcall] | `17,154.90` | `5.81` | `143.79x` |
|| [GraphQL JIT] | `1,060.72` | `93.70` | `8.89x` |
|| [async-graphql] | `1,009.70` | `98.34` | `8.46x` |
|| [Caliban] | `755.14` | `132.19` | `6.33x` |
|| [Gqlgen] | `405.57` | `243.04` | `3.40x` |
|| [Netflix DGS] | `186.16` | `517.57` | `1.56x` |
|| [Apollo GraphQL] | `131.35` | `696.34` | `1.10x` |
|| [Hasura] | `119.31` | `790.66` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,715.90` | `3.06` | `70.63x` |
|| [async-graphql] | `5,213.73` | `19.25` | `11.26x` |
|| [Caliban] | `4,927.21` | `20.77` | `10.64x` |
|| [Gqlgen] | `1,140.28` | `95.69` | `2.46x` |
|| [GraphQL JIT] | `1,100.69` | `90.66` | `2.38x` |
|| [Apollo GraphQL] | `894.02` | `112.34` | `1.93x` |
|| [Netflix DGS] | `806.92` | `124.50` | `1.74x` |
|| [Hasura] | `463.20` | `221.04` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `38,979.00` | `2.57` | `23.56x` |
|| [Caliban] | `33,933.80` | `2.95` | `20.51x` |
|| [Gqlgen] | `24,341.50` | `8.61` | `14.71x` |
|| [async-graphql] | `23,958.40` | `4.20` | `14.48x` |
|| [GraphQL JIT] | `4,512.66` | `22.10` | `2.73x` |
|| [Netflix DGS] | `4,227.72` | `28.72` | `2.56x` |
|| [Apollo GraphQL] | `4,043.02` | `27.44` | `2.44x` |
|| [Hasura] | `1,654.32` | `67.22` | `1.00x` |

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
