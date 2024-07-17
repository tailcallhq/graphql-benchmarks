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
|| [Tailcall] | `30,822.60` | `3.23` | `115.47x` |
|| [async-graphql] | `1,904.35` | `52.45` | `7.13x` |
|| [Caliban] | `1,527.17` | `65.30` | `5.72x` |
|| [Hasura] | `1,514.28` | `65.79` | `5.67x` |
|| [GraphQL JIT] | `1,368.98` | `72.74` | `5.13x` |
|| [Gqlgen] | `779.73` | `127.19` | `2.92x` |
|| [Netflix DGS] | `355.78` | `250.19` | `1.33x` |
|| [Apollo GraphQL] | `266.93` | `367.54` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,323.40` | `1.60` | `44.39x` |
|| [async-graphql] | `9,547.12` | `10.57` | `6.80x` |
|| [Caliban] | `9,079.53` | `11.37` | `6.47x` |
|| [Hasura] | `2,555.54` | `39.13` | `1.82x` |
|| [Gqlgen] | `2,209.83` | `46.86` | `1.57x` |
|| [Apollo GraphQL] | `1,720.97` | `58.04` | `1.23x` |
|| [Netflix DGS] | `1,586.13` | `70.10` | `1.13x` |
|| [GraphQL JIT] | `1,404.11` | `71.12` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,905.20` | `1.14` | `26.30x` |
|| [Tailcall] | `63,586.70` | `1.58` | `24.63x` |
|| [async-graphql] | `50,663.30` | `2.02` | `19.62x` |
|| [Gqlgen] | `48,111.00` | `5.21` | `18.63x` |
|| [Netflix DGS] | `8,279.23` | `14.56` | `3.21x` |
|| [Apollo GraphQL] | `7,922.58` | `12.87` | `3.07x` |
|| [GraphQL JIT] | `5,220.03` | `19.13` | `2.02x` |
|| [Hasura] | `2,581.79` | `38.64` | `1.00x` |

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
