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
|| [Tailcall] | `29,295.70` | `3.40` | `125.83x` |
|| [async-graphql] | `1,977.41` | `50.90` | `8.49x` |
|| [Caliban] | `1,727.51` | `57.62` | `7.42x` |
|| [GraphQL JIT] | `1,360.38` | `73.19` | `5.84x` |
|| [Gqlgen] | `757.41` | `131.01` | `3.25x` |
|| [Netflix DGS] | `368.13` | `160.44` | `1.58x` |
|| [Apollo GraphQL] | `273.34` | `360.27` | `1.17x` |
|| [Hasura] | `232.81` | `426.48` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,888.10` | `1.69` | `80.89x` |
|| [async-graphql] | `10,228.90` | `10.05` | `14.05x` |
|| [Caliban] | `9,844.01` | `10.49` | `13.52x` |
|| [Gqlgen] | `2,104.23` | `49.25` | `2.89x` |
|| [Apollo GraphQL] | `1,769.39` | `56.44` | `2.43x` |
|| [Netflix DGS] | `1,586.79` | `70.83` | `2.18x` |
|| [GraphQL JIT] | `1,404.53` | `71.09` | `1.93x` |
|| [Hasura] | `728.04` | `137.26` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,745.70` | `1.10` | `26.37x` |
|| [Tailcall] | `58,961.20` | `1.71` | `22.95x` |
|| [async-graphql] | `47,568.30` | `2.17` | `18.52x` |
|| [Gqlgen] | `46,872.30` | `4.98` | `18.25x` |
|| [Netflix DGS] | `8,164.72` | `14.78` | `3.18x` |
|| [Apollo GraphQL] | `8,080.80` | `12.52` | `3.15x` |
|| [GraphQL JIT] | `5,174.30` | `19.30` | `2.01x` |
|| [Hasura] | `2,568.95` | `39.48` | `1.00x` |

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
