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
|| [Tailcall] | `21,556.30` | `4.62` | `192.55x` |
|| [GraphQL JIT] | `1,127.47` | `88.23` | `10.07x` |
|| [async-graphql] | `1,000.01` | `99.30` | `8.93x` |
|| [Caliban] | `738.71` | `135.74` | `6.60x` |
|| [Gqlgen] | `353.49` | `278.71` | `3.16x` |
|| [Netflix DGS] | `187.01` | `516.96` | `1.67x` |
|| [Apollo GraphQL] | `131.41` | `697.53` | `1.17x` |
|| [Hasura] | `111.95` | `768.03` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,271.00` | `3.00` | `82.13x` |
|| [async-graphql] | `5,165.79` | `19.38` | `12.75x` |
|| [Caliban] | `4,957.68` | `20.60` | `12.24x` |
|| [GraphQL JIT] | `1,158.25` | `86.17` | `2.86x` |
|| [Gqlgen] | `1,035.00` | `106.24` | `2.55x` |
|| [Apollo GraphQL] | `897.77` | `111.78` | `2.22x` |
|| [Netflix DGS] | `805.57` | `124.93` | `1.99x` |
|| [Hasura] | `405.11` | `256.87` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `40,723.40` | `2.46` | `28.35x` |
|| [Caliban] | `33,626.60` | `2.98` | `23.41x` |
|| [async-graphql] | `23,977.80` | `4.18` | `16.69x` |
|| [Gqlgen] | `22,873.00` | `8.58` | `15.92x` |
|| [GraphQL JIT] | `4,586.00` | `21.75` | `3.19x` |
|| [Netflix DGS] | `4,201.63` | `28.17` | `2.92x` |
|| [Apollo GraphQL] | `4,060.00` | `27.79` | `2.83x` |
|| [Hasura] | `1,436.62` | `70.27` | `1.00x` |

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
