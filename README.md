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
|| [Tailcall] | `20,238.80` | `4.87` | `178.58x` |
|| [async-graphql] | `1,037.41` | `95.83` | `9.15x` |
|| [GraphQL JIT] | `1,021.19` | `97.35` | `9.01x` |
|| [Caliban] | `945.06` | `105.63` | `8.34x` |
|| [Gqlgen] | `400.17` | `246.66` | `3.53x` |
|| [Netflix DGS] | `184.63` | `540.46` | `1.63x` |
|| [Apollo GraphQL] | `132.62` | `694.66` | `1.17x` |
|| [Hasura] | `113.33` | `791.64` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `32,551.80` | `3.02` | `68.69x` |
|| [Caliban] | `5,622.97` | `17.85` | `11.87x` |
|| [async-graphql] | `5,160.43` | `19.39` | `10.89x` |
|| [Gqlgen] | `1,130.32` | `97.06` | `2.39x` |
|| [GraphQL JIT] | `1,075.30` | `92.72` | `2.27x` |
|| [Apollo GraphQL] | `896.90` | `111.87` | `1.89x` |
|| [Netflix DGS] | `804.04` | `158.50` | `1.70x` |
|| [Hasura] | `473.87` | `220.46` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,453.80` | `2.00` | `30.61x` |
|| [Gqlgen] | `25,963.10` | `4.87` | `16.40x` |
|| [Tailcall] | `25,720.80` | `3.87` | `16.25x` |
|| [async-graphql] | `25,115.00` | `3.98` | `15.87x` |
|| [GraphQL JIT] | `4,401.46` | `22.66` | `2.78x` |
|| [Netflix DGS] | `4,115.39` | `28.69` | `2.60x` |
|| [Apollo GraphQL] | `4,043.06` | `28.39` | `2.55x` |
|| [Hasura] | `1,583.01` | `63.16` | `1.00x` |

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
