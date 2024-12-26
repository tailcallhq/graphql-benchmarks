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
|| [Tailcall] | `21,812.50` | `4.57` | `187.42x` |
|| [GraphQL JIT] | `1,143.93` | `86.93` | `9.83x` |
|| [async-graphql] | `1,012.74` | `98.02` | `8.70x` |
|| [Caliban] | `781.46` | `128.26` | `6.71x` |
|| [Gqlgen] | `404.55` | `243.66` | `3.48x` |
|| [Netflix DGS] | `188.25` | `514.09` | `1.62x` |
|| [Apollo GraphQL] | `130.84` | `700.75` | `1.12x` |
|| [Hasura] | `116.38` | `763.38` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,483.40` | `2.99` | `80.10x` |
|| [async-graphql] | `5,191.56` | `19.27` | `12.42x` |
|| [Caliban] | `4,780.60` | `21.41` | `11.44x` |
|| [GraphQL JIT] | `1,181.22` | `84.48` | `2.83x` |
|| [Gqlgen] | `1,140.25` | `96.10` | `2.73x` |
|| [Apollo GraphQL] | `871.49` | `115.18` | `2.08x` |
|| [Netflix DGS] | `802.84` | `124.89` | `1.92x` |
|| [Hasura] | `418.04` | `246.06` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,055.00` | `2.51` | `26.55x` |
|| [Caliban] | `33,915.40` | `2.96` | `22.48x` |
|| [Gqlgen] | `24,280.40` | `9.41` | `16.09x` |
|| [async-graphql] | `23,974.70` | `4.22` | `15.89x` |
|| [GraphQL JIT] | `4,639.11` | `21.51` | `3.07x` |
|| [Netflix DGS] | `4,109.43` | `29.00` | `2.72x` |
|| [Apollo GraphQL] | `3,927.38` | `28.77` | `2.60x` |
|| [Hasura] | `1,508.74` | `67.02` | `1.00x` |

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
