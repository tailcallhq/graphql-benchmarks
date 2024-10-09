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
|| [Tailcall] | `13,766.70` | `7.23` | `124.22x` |
|| [GraphQL JIT] | `1,129.35` | `88.09` | `10.19x` |
|| [async-graphql] | `1,011.77` | `98.50` | `9.13x` |
|| [Caliban] | `832.49` | `120.44` | `7.51x` |
|| [Gqlgen] | `405.10` | `243.70` | `3.66x` |
|| [Netflix DGS] | `187.00` | `529.08` | `1.69x` |
|| [Apollo GraphQL] | `131.00` | `699.08` | `1.18x` |
|| [Hasura] | `110.82` | `780.48` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,920.30` | `4.53` | `48.56x` |
|| [Caliban] | `5,597.97` | `17.92` | `12.40x` |
|| [async-graphql] | `5,178.23` | `19.32` | `11.47x` |
|| [GraphQL JIT] | `1,173.31` | `85.06` | `2.60x` |
|| [Gqlgen] | `1,116.75` | `97.26` | `2.47x` |
|| [Apollo GraphQL] | `898.16` | `111.93` | `1.99x` |
|| [Netflix DGS] | `806.24` | `159.62` | `1.79x` |
|| [Hasura] | `451.44` | `221.52` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,918.50` | `2.07` | `30.61x` |
|| [Gqlgen] | `25,421.80` | `4.96` | `16.58x` |
|| [async-graphql] | `25,211.00` | `3.95` | `16.45x` |
|| [Tailcall] | `21,487.40` | `4.66` | `14.02x` |
|| [GraphQL JIT] | `4,601.60` | `21.68` | `3.00x` |
|| [Netflix DGS] | `4,154.06` | `28.41` | `2.71x` |
|| [Apollo GraphQL] | `4,063.68` | `28.48` | `2.65x` |
|| [Hasura] | `1,532.92` | `66.31` | `1.00x` |

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
