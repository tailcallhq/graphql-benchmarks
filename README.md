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
|| [Tailcall] | `30,224.40` | `3.30` | `141.88x` |
|| [async-graphql] | `1,992.36` | `50.50` | `9.35x` |
|| [Caliban] | `1,753.17` | `56.80` | `8.23x` |
|| [GraphQL JIT] | `1,318.51` | `75.50` | `6.19x` |
|| [Gqlgen] | `787.82` | `126.00` | `3.70x` |
|| [Netflix DGS] | `368.37` | `120.04` | `1.73x` |
|| [Apollo GraphQL] | `273.23` | `359.68` | `1.28x` |
|| [Hasura] | `213.03` | `464.69` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `59,588.20` | `1.67` | `90.94x` |
|| [async-graphql] | `10,096.70` | `10.00` | `15.41x` |
|| [Caliban] | `9,744.65` | `10.59` | `14.87x` |
|| [Gqlgen] | `2,192.63` | `47.10` | `3.35x` |
|| [Apollo GraphQL] | `1,792.26` | `55.72` | `2.74x` |
|| [Netflix DGS] | `1,600.56` | `71.11` | `2.44x` |
|| [GraphQL JIT] | `1,352.19` | `73.85` | `2.06x` |
|| [Hasura] | `655.25` | `152.98` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,748.90` | `1.08` | `29.46x` |
|| [Tailcall] | `59,671.70` | `1.69` | `25.57x` |
|| [async-graphql] | `49,247.30` | `2.13` | `21.10x` |
|| [Gqlgen] | `48,085.20` | `5.25` | `20.61x` |
|| [Netflix DGS] | `8,210.96` | `14.94` | `3.52x` |
|| [Apollo GraphQL] | `8,148.35` | `12.55` | `3.49x` |
|| [GraphQL JIT] | `5,131.41` | `19.46` | `2.20x` |
|| [Hasura] | `2,333.48` | `42.74` | `1.00x` |

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
