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
|| [Tailcall] | `29,397.80` | `3.39` | `310.25x` |
|| [async-graphql] | `2,002.32` | `50.25` | `21.13x` |
|| [Caliban] | `1,682.31` | `59.09` | `17.75x` |
|| [GraphQL JIT] | `1,354.53` | `73.51` | `14.29x` |
|| [Gqlgen] | `786.51` | `126.18` | `8.30x` |
|| [Netflix DGS] | `362.10` | `157.77` | `3.82x` |
|| [Apollo GraphQL] | `273.13` | `359.70` | `2.88x` |
|| [Hasura] | `94.76` | `583.92` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,398.60` | `1.71` | `67.24x` |
|| [async-graphql] | `9,581.84` | `10.81` | `11.03x` |
|| [Caliban] | `9,494.41` | `10.92` | `10.93x` |
|| [Gqlgen] | `2,185.83` | `47.33` | `2.52x` |
|| [Apollo GraphQL] | `1,775.53` | `56.25` | `2.04x` |
|| [Netflix DGS] | `1,570.81` | `71.35` | `1.81x` |
|| [GraphQL JIT] | `1,393.11` | `71.67` | `1.60x` |
|| [Hasura] | `868.45` | `114.92` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,143.10` | `1.14` | `25.50x` |
|| [Tailcall] | `59,136.90` | `1.71` | `22.46x` |
|| [async-graphql] | `48,055.50` | `2.29` | `18.25x` |
|| [Gqlgen] | `47,694.50` | `5.05` | `18.12x` |
|| [Apollo GraphQL] | `8,162.54` | `12.45` | `3.10x` |
|| [Netflix DGS] | `8,083.19` | `15.31` | `3.07x` |
|| [GraphQL JIT] | `5,195.12` | `19.22` | `1.97x` |
|| [Hasura] | `2,632.85` | `37.90` | `1.00x` |

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
