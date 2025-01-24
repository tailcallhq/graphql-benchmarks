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
|| [Tailcall] | `23,827.70` | `4.11` | `207.96x` |
|| [GraphQL JIT] | `1,096.31` | `90.78` | `9.57x` |
|| [async-graphql] | `1,011.59` | `98.23` | `8.83x` |
|| [Caliban] | `814.18` | `123.35` | `7.11x` |
|| [Gqlgen] | `387.16` | `254.85` | `3.38x` |
|| [Netflix DGS] | `186.05` | `530.18` | `1.62x` |
|| [Apollo GraphQL] | `130.88` | `700.48` | `1.14x` |
|| [Hasura] | `114.58` | `810.96` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `36,514.20` | `2.68` | `88.52x` |
|| [Caliban] | `5,389.58` | `18.63` | `13.07x` |
|| [async-graphql] | `5,046.31` | `19.84` | `12.23x` |
|| [GraphQL JIT] | `1,128.59` | `88.40` | `2.74x` |
|| [Gqlgen] | `1,091.62` | `100.97` | `2.65x` |
|| [Apollo GraphQL] | `885.37` | `113.51` | `2.15x` |
|| [Netflix DGS] | `800.99` | `157.87` | `1.94x` |
|| [Hasura] | `412.50` | `242.82` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `47,509.00` | `2.05` | `30.39x` |
|| [Caliban] | `47,163.30` | `2.06` | `30.17x` |
|| [Gqlgen] | `25,220.30` | `4.91` | `16.13x` |
|| [async-graphql] | `25,167.10` | `3.96` | `16.10x` |
|| [GraphQL JIT] | `4,527.95` | `22.04` | `2.90x` |
|| [Netflix DGS] | `4,172.12` | `27.98` | `2.67x` |
|| [Apollo GraphQL] | `4,073.80` | `28.27` | `2.61x` |
|| [Hasura] | `1,563.39` | `65.06` | `1.00x` |

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
