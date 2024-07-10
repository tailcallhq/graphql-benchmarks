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
|| [Tailcall] | `28,424.10` | `3.50` | `100.98x` |
|| [async-graphql] | `1,855.27` | `54.21` | `6.59x` |
|| [Caliban] | `1,586.46` | `62.66` | `5.64x` |
|| [Hasura] | `1,442.81` | `69.06` | `5.13x` |
|| [GraphQL JIT] | `1,369.14` | `76.46` | `4.86x` |
|| [Gqlgen] | `755.22` | `131.37` | `2.68x` |
|| [Netflix DGS] | `358.69` | `172.60` | `1.27x` |
|| [Apollo GraphQL] | `281.48` | `349.71` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `60,750.00` | `1.64` | `43.61x` |
|| [async-graphql] | `9,351.63` | `10.84` | `6.71x` |
|| [Caliban] | `9,276.55` | `11.13` | `6.66x` |
|| [Hasura] | `2,389.42` | `41.82` | `1.72x` |
|| [Gqlgen] | `2,142.69` | `48.41` | `1.54x` |
|| [Apollo GraphQL] | `1,735.57` | `57.55` | `1.25x` |
|| [Netflix DGS] | `1,597.25` | `69.08` | `1.15x` |
|| [GraphQL JIT] | `1,393.10` | `72.96` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,789.00` | `1.08` | `28.21x` |
|| [Tailcall] | `63,676.60` | `1.58` | `26.50x` |
|| [async-graphql] | `50,534.10` | `2.12` | `21.03x` |
|| [Gqlgen] | `45,999.40` | `5.31` | `19.14x` |
|| [Netflix DGS] | `8,153.80` | `15.20` | `3.39x` |
|| [Apollo GraphQL] | `7,890.27` | `12.98` | `3.28x` |
|| [GraphQL JIT] | `5,230.29` | `27.05` | `2.18x` |
|| [Hasura] | `2,403.13` | `41.51` | `1.00x` |

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
