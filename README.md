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
|| [Tailcall] | `28,921.40` | `3.44` | `284.11x` |
|| [async-graphql] | `2,050.36` | `48.80` | `20.14x` |
|| [Caliban] | `1,735.78` | `57.53` | `17.05x` |
|| [GraphQL JIT] | `1,330.52` | `74.84` | `13.07x` |
|| [Gqlgen] | `767.45` | `129.30` | `7.54x` |
|| [Netflix DGS] | `366.71` | `164.89` | `3.60x` |
|| [Apollo GraphQL] | `263.57` | `372.90` | `2.59x` |
|| [Hasura] | `101.80` | `471.69` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,448.20` | `1.73` | `68.68x` |
|| [async-graphql] | `9,956.51` | `10.19` | `11.90x` |
|| [Caliban] | `9,850.25` | `10.47` | `11.78x` |
|| [Gqlgen] | `2,069.87` | `50.00` | `2.47x` |
|| [Apollo GraphQL] | `1,720.55` | `58.03` | `2.06x` |
|| [Netflix DGS] | `1,593.72` | `70.80` | `1.91x` |
|| [GraphQL JIT] | `1,373.36` | `72.71` | `1.64x` |
|| [Hasura] | `836.40` | `119.29` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,075.40` | `1.09` | `26.29x` |
|| [Tailcall] | `58,359.00` | `1.72` | `22.87x` |
|| [async-graphql] | `48,312.50` | `2.16` | `18.94x` |
|| [Gqlgen] | `45,293.70` | `5.20` | `17.75x` |
|| [Netflix DGS] | `8,169.65` | `15.11` | `3.20x` |
|| [Apollo GraphQL] | `7,939.59` | `12.76` | `3.11x` |
|| [GraphQL JIT] | `5,165.36` | `19.33` | `2.02x` |
|| [Hasura] | `2,551.35` | `39.37` | `1.00x` |

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
