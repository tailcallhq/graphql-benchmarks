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
|| [Tailcall] | `68,164.60` | `1.41` | `621.81x` |
|| [Netflix DGS] | `1,955.20` | `31.78` | `17.84x` |
|| [GraphQL JIT] | `1,131.02` | `87.89` | `10.32x` |
|| [async-graphql] | `992.54` | `100.03` | `9.05x` |
|| [Caliban] | `827.15` | `120.77` | `7.55x` |
|| [Gqlgen] | `381.88` | `258.10` | `3.48x` |
|| [Apollo GraphQL] | `133.71` | `691.39` | `1.22x` |
|| [Hasura] | `109.62` | `760.22` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `161,962.00` | `579.05` | `379.10x` |
|| [Netflix DGS] | `8,622.55` | `13.89` | `20.18x` |
|| [async-graphql] | `5,134.06` | `19.48` | `12.02x` |
|| [Caliban] | `4,928.38` | `20.77` | `11.54x` |
|| [GraphQL JIT] | `1,157.47` | `86.22` | `2.71x` |
|| [Gqlgen] | `1,107.18` | `99.40` | `2.59x` |
|| [Apollo GraphQL] | `913.30` | `109.88` | `2.14x` |
|| [Hasura] | `427.23` | `244.74` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `358,593.00` | `269.85` | `253.00x` |
|| [Caliban] | `33,817.60` | `2.95` | `23.86x` |
|| [Netflix DGS] | `27,269.00` | `3.82` | `19.24x` |
|| [Gqlgen] | `24,278.90` | `11.00` | `17.13x` |
|| [async-graphql] | `23,779.50` | `4.23` | `16.78x` |
|| [GraphQL JIT] | `4,585.12` | `21.77` | `3.23x` |
|| [Apollo GraphQL] | `4,085.79` | `26.76` | `2.88x` |
|| [Hasura] | `1,417.39` | `70.47` | `1.00x` |

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
