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
|| [Tailcall] | `26,053.80` | `3.82` | `132.44x` |
|| [async-graphql] | `2,037.76` | `49.34` | `10.36x` |
|| [Caliban] | `1,554.56` | `63.96` | `7.90x` |
|| [GraphQL JIT] | `1,366.96` | `72.85` | `6.95x` |
|| [Gqlgen] | `801.15` | `123.92` | `4.07x` |
|| [Netflix DGS] | `368.80` | `166.16` | `1.87x` |
|| [Apollo GraphQL] | `270.88` | `363.13` | `1.38x` |
|| [Hasura] | `196.73` | `495.47` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `54,877.90` | `1.82` | `63.59x` |
|| [async-graphql] | `9,697.99` | `10.47` | `11.24x` |
|| [Caliban] | `9,117.56` | `11.34` | `10.56x` |
|| [Gqlgen] | `2,213.88` | `46.77` | `2.57x` |
|| [Apollo GraphQL] | `1,745.78` | `57.21` | `2.02x` |
|| [Netflix DGS] | `1,591.93` | `70.12` | `1.84x` |
|| [GraphQL JIT] | `1,407.22` | `70.97` | `1.63x` |
|| [Hasura] | `863.02` | `115.63` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `62,435.60` | `1.18` | `22.21x` |
|| [Tailcall] | `57,240.30` | `1.76` | `20.36x` |
|| [async-graphql] | `47,686.90` | `2.12` | `16.96x` |
|| [Gqlgen] | `47,641.30` | `5.21` | `16.95x` |
|| [Netflix DGS] | `8,191.99` | `14.79` | `2.91x` |
|| [Apollo GraphQL] | `8,149.65` | `12.50` | `2.90x` |
|| [GraphQL JIT] | `5,236.03` | `19.07` | `1.86x` |
|| [Hasura] | `2,811.23` | `35.94` | `1.00x` |

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
