# GraphQL Benchmarks <!-- omit from toc -->

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tailcallhq/graphql-benchmarks)

Explore and compare the performance of the fastest GraphQL frameworks through our comprehensive benchmarks.

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [Benchmark Results](#benchmark-results)
- [Architecture](#architecture)
  - [K6](#k6)
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

| Throughput (Higher is better) | Latency (Lower is better) | 
|-------:|--------:|
|  `{{ posts { id userId title user { id name email }}}}` |
| ![](assets/posts_users_req.png) | ![](assets/posts_users_latency.png) |
|  `{ posts { title }}` |
| ![](assets/posts_req.png) | ![](assets/posts_latency.png) |
|  `{greet}` |
| ![](assets/greet_req.png) | ![](assets/greet_latency.png) |

<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `29,665.80` | `3.36` | `425.07x` |
|| [async-graphql] | `1,851.17` | `54.68` | `26.52x` |
|| [Caliban] | `1,576.28` | `63.08` | `22.59x` |
|| [GraphQL JIT] | `1,365.61` | `72.93` | `19.57x` |
|| [Gqlgen] | `775.69` | `127.90` | `11.11x` |
|| [Netflix DGS] | `363.35` | `176.43` | `5.21x` |
|| [Apollo GraphQL] | `274.89` | `357.34` | `3.94x` |
|| [Hasura] | `69.79` | `547.07` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,926.60` | `1.69` | `67.13x` |
|| [async-graphql] | `9,316.32` | `10.76` | `10.61x` |
|| [Caliban] | `9,125.46` | `11.31` | `10.40x` |
|| [Gqlgen] | `2,208.06` | `46.75` | `2.52x` |
|| [Apollo GraphQL] | `1,781.77` | `56.05` | `2.03x` |
|| [Netflix DGS] | `1,609.56` | `68.96` | `1.83x` |
|| [GraphQL JIT] | `1,400.50` | `71.31` | `1.60x` |
|| [Hasura] | `877.86` | `113.67` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,097.90` | `1.10` | `25.87x` |
|| [Tailcall] | `60,001.70` | `1.67` | `22.79x` |
|| [Gqlgen] | `48,414.40` | `5.11` | `18.39x` |
|| [async-graphql] | `47,752.20` | `2.19` | `18.14x` |
|| [Netflix DGS] | `8,383.83` | `14.93` | `3.18x` |
|| [Apollo GraphQL] | `8,190.26` | `12.39` | `3.11x` |
|| [GraphQL JIT] | `5,175.24` | `19.29` | `1.97x` |
|| [Hasura] | `2,632.45` | `37.92` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->

## Architecture

![Architecture Diagram](assets/architecture.png)

A client (`k6`) sends requests to a GraphQL server to fetch post titles. The GraphQL server, in turn, retrieves data from an external source, `jsonplaceholder.typicode.com`, routed through the `nginx` reverse proxy.

### K6

`k6` serves as our test client, sending GraphQL requests at a high rate.

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
