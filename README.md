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
|| [Tailcall] | `21,130.70` | `4.73` | `177.93x` |
|| [GraphQL JIT] | `1,062.15` | `93.55` | `8.94x` |
|| [async-graphql] | `947.19` | `104.78` | `7.98x` |
|| [Caliban] | `738.85` | `136.07` | `6.22x` |
|| [Gqlgen] | `387.34` | `254.36` | `3.26x` |
|| [Netflix DGS] | `186.92` | `517.28` | `1.57x` |
|| [Apollo GraphQL] | `132.21` | `695.16` | `1.11x` |
|| [Hasura] | `118.76` | `774.49` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `33,165.00` | `3.02` | `71.28x` |
|| [async-graphql] | `5,065.24` | `20.01` | `10.89x` |
|| [Caliban] | `4,754.92` | `21.56` | `10.22x` |
|| [GraphQL JIT] | `1,135.46` | `87.91` | `2.44x` |
|| [Gqlgen] | `1,101.39` | `99.69` | `2.37x` |
|| [Apollo GraphQL] | `905.12` | `110.95` | `1.95x` |
|| [Netflix DGS] | `807.80` | `124.74` | `1.74x` |
|| [Hasura] | `465.28` | `231.46` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `39,700.30` | `2.53` | `27.30x` |
|| [Caliban] | `32,756.20` | `3.08` | `22.53x` |
|| [Gqlgen] | `24,512.60` | `8.40` | `16.86x` |
|| [async-graphql] | `23,673.50` | `4.22` | `16.28x` |
|| [GraphQL JIT] | `4,568.26` | `21.84` | `3.14x` |
|| [Netflix DGS] | `4,183.74` | `28.25` | `2.88x` |
|| [Apollo GraphQL] | `4,066.61` | `27.50` | `2.80x` |
|| [Hasura] | `1,454.17` | `68.45` | `1.00x` |

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
