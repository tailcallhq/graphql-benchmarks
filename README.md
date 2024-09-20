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
|| [Tailcall] | `20,266.10` | `4.87` | `180.53x` |
|| [GraphQL JIT] | `1,105.19` | `90.00` | `9.84x` |
|| [async-graphql] | `1,044.45` | `95.37` | `9.30x` |
|| [Caliban] | `814.66` | `122.91` | `7.26x` |
|| [Gqlgen] | `379.97` | `259.23` | `3.38x` |
|| [Netflix DGS] | `184.00` | `530.22` | `1.64x` |
|| [Apollo GraphQL] | `126.30` | `722.21` | `1.13x` |
|| [Hasura] | `112.26` | `820.71` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,563.40` | `3.02` | `83.30x` |
|| [async-graphql] | `5,228.94` | `19.15` | `13.38x` |
|| [Caliban] | `5,135.78` | `19.61` | `13.14x` |
|| [GraphQL JIT] | `1,172.97` | `85.10` | `3.00x` |
|| [Gqlgen] | `1,097.69` | `100.00` | `2.81x` |
|| [Apollo GraphQL] | `852.01` | `117.95` | `2.18x` |
|| [Netflix DGS] | `796.17` | `154.84` | `2.04x` |
|| [Hasura] | `390.91` | `257.49` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `45,401.00` | `2.13` | `28.52x` |
|| [async-graphql] | `25,859.40` | `3.85` | `16.24x` |
|| [Tailcall] | `25,780.30` | `3.86` | `16.19x` |
|| [Gqlgen] | `24,798.50` | `5.15` | `15.58x` |
|| [GraphQL JIT] | `4,691.72` | `21.28` | `2.95x` |
|| [Netflix DGS] | `4,120.65` | `27.62` | `2.59x` |
|| [Apollo GraphQL] | `3,860.08` | `30.81` | `2.42x` |
|| [Hasura] | `1,592.04` | `63.56` | `1.00x` |

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
