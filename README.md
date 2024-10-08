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
|| [Tailcall] | `13,722.80` | `7.25` | `119.63x` |
|| [GraphQL JIT] | `1,116.08` | `89.10` | `9.73x` |
|| [async-graphql] | `1,095.31` | `90.74` | `9.55x` |
|| [Caliban] | `911.51` | `109.86` | `7.95x` |
|| [Gqlgen] | `388.99` | `253.38` | `3.39x` |
|| [Netflix DGS] | `187.70` | `530.22` | `1.64x` |
|| [Apollo GraphQL] | `122.09` | `744.75` | `1.06x` |
|| [Hasura] | `114.71` | `726.70` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `21,465.30` | `4.63` | `48.38x` |
|| [Caliban] | `5,651.02` | `17.76` | `12.74x` |
|| [async-graphql] | `5,329.26` | `18.80` | `12.01x` |
|| [GraphQL JIT] | `1,158.96` | `86.11` | `2.61x` |
|| [Gqlgen] | `1,099.32` | `99.15` | `2.48x` |
|| [Apollo GraphQL] | `837.37` | `119.99` | `1.89x` |
|| [Netflix DGS] | `807.39` | `152.43` | `1.82x` |
|| [Hasura] | `443.68` | `231.01` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,720.80` | `1.99` | `30.67x` |
|| [async-graphql] | `25,477.40` | `3.92` | `16.04x` |
|| [Gqlgen] | `25,398.20` | `5.00` | `15.99x` |
|| [Tailcall] | `20,793.40` | `4.82` | `13.09x` |
|| [GraphQL JIT] | `4,504.44` | `22.16` | `2.84x` |
|| [Netflix DGS] | `4,184.06` | `27.15` | `2.63x` |
|| [Apollo GraphQL] | `3,860.75` | `30.08` | `2.43x` |
|| [Hasura] | `1,588.54` | `63.48` | `1.00x` |

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
