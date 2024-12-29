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
|| [Tailcall] | `21,805.50` | `4.58` | `195.18x` |
|| [GraphQL JIT] | `1,130.37` | `87.97` | `10.12x` |
|| [async-graphql] | `994.53` | `99.98` | `8.90x` |
|| [Caliban] | `814.52` | `122.65` | `7.29x` |
|| [Gqlgen] | `383.84` | `256.67` | `3.44x` |
|| [Netflix DGS] | `190.32` | `508.23` | `1.70x` |
|| [Apollo GraphQL] | `134.55` | `685.59` | `1.20x` |
|| [Hasura] | `111.72` | `817.47` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,349.60` | `2.99` | `75.67x` |
|| [async-graphql] | `5,158.84` | `19.61` | `11.71x` |
|| [Caliban] | `4,888.97` | `20.86` | `11.09x` |
|| [GraphQL JIT] | `1,157.29` | `86.23` | `2.63x` |
|| [Gqlgen] | `1,106.97` | `99.14` | `2.51x` |
|| [Apollo GraphQL] | `861.38` | `116.50` | `1.95x` |
|| [Netflix DGS] | `820.64` | `122.47` | `1.86x` |
|| [Hasura] | `440.73` | `228.68` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,965.50` | `2.50` | `26.98x` |
|| [Caliban] | `34,302.70` | `2.92` | `23.16x` |
|| [Gqlgen] | `23,756.00` | `8.86` | `16.04x` |
|| [async-graphql] | `23,734.20` | `4.24` | `16.02x` |
|| [GraphQL JIT] | `4,629.86` | `21.54` | `3.13x` |
|| [Netflix DGS] | `4,267.34` | `28.89` | `2.88x` |
|| [Apollo GraphQL] | `4,016.63` | `27.78` | `2.71x` |
|| [Hasura] | `1,481.41` | `67.56` | `1.00x` |

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
