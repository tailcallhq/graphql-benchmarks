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
|| [Tailcall] | `21,809.10` | `4.58` | `182.03x` |
|| [GraphQL JIT] | `1,090.13` | `91.29` | `9.10x` |
|| [async-graphql] | `1,002.27` | `99.19` | `8.37x` |
|| [Caliban] | `789.64` | `126.71` | `6.59x` |
|| [Gqlgen] | `392.03` | `251.40` | `3.27x` |
|| [Netflix DGS] | `187.71` | `515.03` | `1.57x` |
|| [Apollo GraphQL] | `127.86` | `715.84` | `1.07x` |
|| [Hasura] | `119.81` | `754.88` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,217.70` | `3.01` | `71.48x` |
|| [async-graphql] | `5,258.18` | `19.07` | `11.32x` |
|| [Caliban] | `4,805.40` | `21.27` | `10.34x` |
|| [GraphQL JIT] | `1,136.22` | `87.84` | `2.45x` |
|| [Gqlgen] | `1,118.64` | `97.86` | `2.41x` |
|| [Apollo GraphQL] | `888.53` | `112.92` | `1.91x` |
|| [Netflix DGS] | `805.54` | `124.65` | `1.73x` |
|| [Hasura] | `464.69` | `221.71` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,239.20` | `2.55` | `26.30x` |
|| [Caliban] | `33,335.80` | `3.01` | `22.34x` |
|| [async-graphql] | `23,866.80` | `4.20` | `16.00x` |
|| [Gqlgen] | `23,291.10` | `9.81` | `15.61x` |
|| [GraphQL JIT] | `4,359.50` | `23.01` | `2.92x` |
|| [Netflix DGS] | `4,168.11` | `28.68` | `2.79x` |
|| [Apollo GraphQL] | `4,030.15` | `27.08` | `2.70x` |
|| [Hasura] | `1,492.02` | `66.88` | `1.00x` |

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
