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
|| [Tailcall] | `29,719.90` | `3.35` | `238.97x` |
|| [async-graphql] | `2,008.95` | `49.77` | `16.15x` |
|| [Caliban] | `1,682.01` | `59.29` | `13.52x` |
|| [GraphQL JIT] | `1,372.76` | `72.54` | `11.04x` |
|| [Gqlgen] | `802.68` | `123.64` | `6.45x` |
|| [Netflix DGS] | `364.91` | `243.04` | `2.93x` |
|| [Apollo GraphQL] | `258.12` | `380.81` | `2.08x` |
|| [Hasura] | `124.37` | `565.57` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,006.60` | `1.71` | `70.36x` |
|| [async-graphql] | `9,931.90` | `10.10` | `12.05x` |
|| [Caliban] | `9,628.98` | `10.71` | `11.68x` |
|| [Gqlgen] | `2,218.71` | `46.56` | `2.69x` |
|| [Apollo GraphQL] | `1,654.73` | `60.36` | `2.01x` |
|| [Netflix DGS] | `1,598.50` | `70.71` | `1.94x` |
|| [GraphQL JIT] | `1,421.76` | `70.23` | `1.72x` |
|| [Hasura] | `824.48` | `121.08` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `66,314.60` | `1.11` | `27.50x` |
|| [Tailcall] | `58,721.00` | `1.71` | `24.35x` |
|| [async-graphql] | `47,868.50` | `2.12` | `19.85x` |
|| [Gqlgen] | `47,856.00` | `4.95` | `19.85x` |
|| [Netflix DGS] | `8,276.69` | `15.02` | `3.43x` |
|| [Apollo GraphQL] | `7,643.42` | `13.37` | `3.17x` |
|| [GraphQL JIT] | `5,317.42` | `18.78` | `2.21x` |
|| [Hasura] | `2,411.42` | `41.36` | `1.00x` |

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
