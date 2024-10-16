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
|| [Tailcall] | `8,433.05` | `11.84` | `70.89x` |
|| [GraphQL JIT] | `1,100.45` | `90.37` | `9.25x` |
|| [async-graphql] | `968.67` | `102.53` | `8.14x` |
|| [Caliban] | `815.39` | `122.63` | `6.85x` |
|| [Gqlgen] | `395.76` | `249.05` | `3.33x` |
|| [Netflix DGS] | `188.97` | `513.40` | `1.59x` |
|| [Apollo GraphQL] | `139.11` | `666.05` | `1.17x` |
|| [Hasura] | `118.96` | `747.68` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,106.60` | `6.21` | `34.02x` |
|| [async-graphql] | `5,211.74` | `19.21` | `11.01x` |
|| [Caliban] | `4,961.78` | `20.61` | `10.48x` |
|| [GraphQL JIT] | `1,130.55` | `88.27` | `2.39x` |
|| [Gqlgen] | `1,117.77` | `98.73` | `2.36x` |
|| [Apollo GraphQL] | `938.01` | `106.90` | `1.98x` |
|| [Netflix DGS] | `815.75` | `123.59` | `1.72x` |
|| [Hasura] | `473.40` | `233.35` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,437.00` | `3.00` | `20.90x` |
|| [Gqlgen] | `24,539.90` | `9.19` | `15.34x` |
|| [async-graphql] | `23,534.10` | `4.26` | `14.71x` |
|| [Tailcall] | `20,820.30` | `4.83` | `13.01x` |
|| [GraphQL JIT] | `4,509.09` | `22.13` | `2.82x` |
|| [Apollo GraphQL] | `4,249.03` | `25.98` | `2.66x` |
|| [Netflix DGS] | `4,193.12` | `28.95` | `2.62x` |
|| [Hasura] | `1,600.15` | `62.63` | `1.00x` |

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
