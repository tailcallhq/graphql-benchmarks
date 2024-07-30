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
|| [Tailcall] | `27,583.90` | `3.61` | `192.53x` |
|| [async-graphql] | `1,943.64` | `52.19` | `13.57x` |
|| [Caliban] | `1,675.56` | `59.36` | `11.70x` |
|| [GraphQL JIT] | `1,286.54` | `77.37` | `8.98x` |
|| [Gqlgen] | `804.19` | `123.46` | `5.61x` |
|| [Netflix DGS] | `365.85` | `186.80` | `2.55x` |
|| [Apollo GraphQL] | `269.91` | `364.22` | `1.88x` |
|| [Hasura] | `143.27` | `509.46` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `57,366.90` | `1.74` | `65.48x` |
|| [async-graphql] | `9,797.85` | `10.33` | `11.18x` |
|| [Caliban] | `9,549.82` | `10.84` | `10.90x` |
|| [Gqlgen] | `2,239.37` | `46.17` | `2.56x` |
|| [Apollo GraphQL] | `1,752.66` | `56.98` | `2.00x` |
|| [Netflix DGS] | `1,576.98` | `71.48` | `1.80x` |
|| [GraphQL JIT] | `1,314.77` | `75.95` | `1.50x` |
|| [Hasura] | `876.07` | `113.91` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,616.90` | `1.08` | `24.70x` |
|| [Tailcall] | `58,988.60` | `1.71` | `21.55x` |
|| [Gqlgen] | `48,261.80` | `5.08` | `17.63x` |
|| [async-graphql] | `47,671.00` | `2.15` | `17.41x` |
|| [Apollo GraphQL] | `8,061.23` | `12.60` | `2.94x` |
|| [Netflix DGS] | `8,039.81` | `14.99` | `2.94x` |
|| [GraphQL JIT] | `5,051.79` | `19.76` | `1.85x` |
|| [Hasura] | `2,737.47` | `36.53` | `1.00x` |

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
