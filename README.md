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
|| [Tailcall] | `29,988.10` | `3.32` | `132.08x` |
|| [async-graphql] | `2,047.16` | `49.30` | `9.02x` |
|| [Caliban] | `1,722.07` | `58.12` | `7.58x` |
|| [GraphQL JIT] | `1,353.44` | `73.52` | `5.96x` |
|| [Gqlgen] | `801.84` | `123.73` | `3.53x` |
|| [Netflix DGS] | `367.49` | `214.97` | `1.62x` |
|| [Apollo GraphQL] | `274.58` | `357.87` | `1.21x` |
|| [Hasura] | `227.05` | `446.45` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,814.00` | `1.69` | `79.52x` |
|| [async-graphql] | `10,395.40` | `9.71` | `14.06x` |
|| [Caliban] | `9,768.11` | `10.58` | `13.21x` |
|| [Gqlgen] | `2,175.25` | `47.53` | `2.94x` |
|| [Apollo GraphQL] | `1,782.41` | `56.02` | `2.41x` |
|| [Netflix DGS] | `1,606.54` | `70.05` | `2.17x` |
|| [GraphQL JIT] | `1,363.52` | `73.24` | `1.84x` |
|| [Hasura] | `739.62` | `136.60` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,171.40` | `1.07` | `30.06x` |
|| [Tailcall] | `59,259.50` | `1.70` | `26.13x` |
|| [async-graphql] | `49,084.80` | `2.09` | `21.64x` |
|| [Gqlgen] | `47,623.90` | `5.06` | `21.00x` |
|| [Netflix DGS] | `8,238.50` | `14.64` | `3.63x` |
|| [Apollo GraphQL] | `8,156.23` | `12.49` | `3.60x` |
|| [GraphQL JIT] | `5,122.94` | `19.49` | `2.26x` |
|| [Hasura] | `2,267.95` | `44.34` | `1.00x` |

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
