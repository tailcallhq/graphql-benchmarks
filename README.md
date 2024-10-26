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
|| [Tailcall] | `21,271.40` | `4.69` | `177.90x` |
|| [GraphQL JIT] | `1,153.47` | `86.16` | `9.65x` |
|| [async-graphql] | `871.70` | `114.04` | `7.29x` |
|| [Caliban] | `781.81` | `129.33` | `6.54x` |
|| [Gqlgen] | `382.94` | `257.55` | `3.20x` |
|| [Netflix DGS] | `191.05` | `504.61` | `1.60x` |
|| [Apollo GraphQL] | `130.65` | `700.23` | `1.09x` |
|| [Hasura] | `119.57` | `765.57` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,797.30` | `3.05` | `75.42x` |
|| [Caliban] | `4,839.97` | `21.15` | `11.13x` |
|| [async-graphql] | `4,707.06` | `21.33` | `10.82x` |
|| [GraphQL JIT] | `1,192.27` | `83.71` | `2.74x` |
|| [Gqlgen] | `1,093.56` | `100.41` | `2.51x` |
|| [Apollo GraphQL] | `868.68` | `115.53` | `2.00x` |
|| [Netflix DGS] | `813.57` | `123.61` | `1.87x` |
|| [Hasura] | `434.88` | `234.68` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,195.40` | `2.55` | `24.87x` |
|| [Caliban] | `33,483.50` | `2.99` | `21.24x` |
|| [Gqlgen] | `23,823.30` | `9.19` | `15.11x` |
|| [async-graphql] | `23,644.70` | `4.25` | `15.00x` |
|| [GraphQL JIT] | `4,671.68` | `21.36` | `2.96x` |
|| [Netflix DGS] | `4,262.91` | `27.63` | `2.70x` |
|| [Apollo GraphQL] | `3,906.55` | `28.28` | `2.48x` |
|| [Hasura] | `1,576.23` | `65.72` | `1.00x` |

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
