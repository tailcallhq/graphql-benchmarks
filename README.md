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
|| [GraphQL JIT] | `1,126.57` | `88.30` | `10.19x` |
|| [Tailcall] | `1,106.64` | `89.84` | `10.01x` |
|| [async-graphql] | `1,059.89` | `93.71` | `9.59x` |
|| [Caliban] | `864.55` | `115.59` | `7.82x` |
|| [Gqlgen] | `377.98` | `260.67` | `3.42x` |
|| [Netflix DGS] | `181.98` | `535.49` | `1.65x` |
|| [Apollo GraphQL] | `132.34` | `694.79` | `1.20x` |
|| [Hasura] | `110.53` | `667.70` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,422.98` | `18.49` | `12.82x` |
|| [async-graphql] | `5,328.36` | `18.76` | `12.60x` |
|| [Tailcall] | `3,604.42` | `27.74` | `8.52x` |
|| [GraphQL JIT] | `1,163.87` | `85.73` | `2.75x` |
|| [Gqlgen] | `1,066.78` | `102.94` | `2.52x` |
|| [Apollo GraphQL] | `885.62` | `113.35` | `2.09x` |
|| [Netflix DGS] | `786.81` | `155.09` | `1.86x` |
|| [Hasura] | `423.03` | `239.22` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,479.50` | `2.04` | `31.43x` |
|| [async-graphql] | `25,240.10` | `3.95` | `16.71x` |
|| [Gqlgen] | `24,534.80` | `5.23` | `16.24x` |
|| [Tailcall] | `20,380.00` | `4.92` | `13.49x` |
|| [GraphQL JIT] | `4,595.29` | `21.73` | `3.04x` |
|| [Netflix DGS] | `4,064.81` | `30.41` | `2.69x` |
|| [Apollo GraphQL] | `4,042.60` | `29.04` | `2.68x` |
|| [Hasura] | `1,510.48` | `66.84` | `1.00x` |

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
