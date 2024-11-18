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
|| [Tailcall] | `20,845.90` | `4.79` | `175.94x` |
|| [GraphQL JIT] | `1,095.09` | `90.78` | `9.24x` |
|| [async-graphql] | `980.61` | `101.27` | `8.28x` |
|| [Caliban] | `707.11` | `142.41` | `5.97x` |
|| [Gqlgen] | `359.69` | `273.63` | `3.04x` |
|| [Netflix DGS] | `186.33` | `520.38` | `1.57x` |
|| [Apollo GraphQL] | `128.95` | `710.58` | `1.09x` |
|| [Hasura] | `118.48` | `765.81` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,598.50` | `3.07` | `73.86x` |
|| [async-graphql] | `5,074.44` | `19.81` | `11.50x` |
|| [Caliban] | `4,817.30` | `21.22` | `10.92x` |
|| [GraphQL JIT] | `1,143.21` | `87.29` | `2.59x` |
|| [Gqlgen] | `1,063.25` | `103.14` | `2.41x` |
|| [Apollo GraphQL] | `870.14` | `115.38` | `1.97x` |
|| [Netflix DGS] | `803.91` | `125.14` | `1.82x` |
|| [Hasura] | `441.33` | `252.33` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,418.10` | `2.54` | `26.64x` |
|| [Caliban] | `32,556.10` | `3.08` | `22.00x` |
|| [async-graphql] | `23,400.30` | `4.30` | `15.81x` |
|| [Gqlgen] | `22,775.20` | `9.41` | `15.39x` |
|| [GraphQL JIT] | `4,575.54` | `21.80` | `3.09x` |
|| [Netflix DGS] | `4,171.95` | `28.47` | `2.82x` |
|| [Apollo GraphQL] | `3,988.81` | `27.30` | `2.70x` |
|| [Hasura] | `1,479.82` | `68.41` | `1.00x` |

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
