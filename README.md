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
|| [Tailcall] | `30,652.70` | `3.25` | `112.90x` |
|| [async-graphql] | `1,866.11` | `53.68` | `6.87x` |
|| [Hasura] | `1,605.66` | `62.75` | `5.91x` |
|| [Caliban] | `1,571.16` | `63.41` | `5.79x` |
|| [GraphQL JIT] | `1,347.06` | `73.95` | `4.96x` |
|| [Gqlgen] | `767.64` | `129.22` | `2.83x` |
|| [Netflix DGS] | `359.45` | `169.78` | `1.32x` |
|| [Apollo GraphQL] | `271.50` | `361.32` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,553.80` | `1.59` | `44.29x` |
|| [async-graphql] | `9,526.65` | `10.73` | `6.75x` |
|| [Caliban] | `9,217.13` | `11.21` | `6.53x` |
|| [Hasura] | `2,534.96` | `39.44` | `1.79x` |
|| [Gqlgen] | `2,165.15` | `47.74` | `1.53x` |
|| [Apollo GraphQL] | `1,776.70` | `56.22` | `1.26x` |
|| [Netflix DGS] | `1,601.83` | `69.59` | `1.13x` |
|| [GraphQL JIT] | `1,412.27` | `70.70` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `69,255.10` | `1.01` | `26.58x` |
|| [Tailcall] | `63,947.80` | `1.57` | `24.55x` |
|| [async-graphql] | `51,700.90` | `1.99` | `19.85x` |
|| [Gqlgen] | `48,335.60` | `5.14` | `18.55x` |
|| [Netflix DGS] | `8,308.71` | `14.52` | `3.19x` |
|| [Apollo GraphQL] | `8,111.32` | `12.54` | `3.11x` |
|| [GraphQL JIT] | `5,275.33` | `18.92` | `2.03x` |
|| [Hasura] | `2,605.05` | `38.33` | `1.00x` |

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
