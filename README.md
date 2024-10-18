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
|| [Tailcall] | `8,344.10` | `11.96` | `69.48x` |
|| [GraphQL JIT] | `1,080.19` | `92.07` | `8.99x` |
|| [async-graphql] | `1,000.07` | `99.21` | `8.33x` |
|| [Caliban] | `791.13` | `126.39` | `6.59x` |
|| [Gqlgen] | `377.87` | `260.58` | `3.15x` |
|| [Netflix DGS] | `189.23` | `510.56` | `1.58x` |
|| [Apollo GraphQL] | `129.86` | `706.47` | `1.08x` |
|| [Hasura] | `120.10` | `747.75` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `16,040.00` | `6.23` | `34.26x` |
|| [async-graphql] | `5,183.39` | `19.29` | `11.07x` |
|| [Caliban] | `4,905.10` | `20.81` | `10.48x` |
|| [GraphQL JIT] | `1,129.27` | `88.41` | `2.41x` |
|| [Gqlgen] | `1,105.90` | `98.87` | `2.36x` |
|| [Apollo GraphQL] | `879.10` | `114.12` | `1.88x` |
|| [Netflix DGS] | `809.65` | `124.09` | `1.73x` |
|| [Hasura] | `468.23` | `222.41` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `33,197.00` | `3.02` | `19.91x` |
|| [Gqlgen] | `23,698.40` | `9.55` | `14.21x` |
|| [async-graphql] | `23,629.90` | `4.23` | `14.17x` |
|| [Tailcall] | `20,791.00` | `4.83` | `12.47x` |
|| [GraphQL JIT] | `4,486.01` | `22.20` | `2.69x` |
|| [Netflix DGS] | `4,207.19` | `27.91` | `2.52x` |
|| [Apollo GraphQL] | `3,989.54` | `28.11` | `2.39x` |
|| [Hasura] | `1,667.59` | `65.92` | `1.00x` |

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
