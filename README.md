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
|| [Tailcall] | `29,496.60` | `3.38` | `196.74x` |
|| [async-graphql] | `1,805.45` | `55.70` | `12.04x` |
|| [Caliban] | `1,547.91` | `64.33` | `10.32x` |
|| [GraphQL JIT] | `1,335.26` | `74.60` | `8.91x` |
|| [Gqlgen] | `772.80` | `128.41` | `5.15x` |
|| [Netflix DGS] | `358.06` | `177.42` | `2.39x` |
|| [Apollo GraphQL] | `268.25` | `366.16` | `1.79x` |
|| [Hasura] | `149.93` | `549.07` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `58,939.60` | `1.69` | `67.77x` |
|| [Caliban] | `9,238.76` | `11.16` | `10.62x` |
|| [async-graphql] | `9,138.76` | `11.34` | `10.51x` |
|| [Gqlgen] | `2,136.19` | `48.48` | `2.46x` |
|| [Apollo GraphQL] | `1,775.87` | `56.26` | `2.04x` |
|| [Netflix DGS] | `1,593.80` | `69.82` | `1.83x` |
|| [GraphQL JIT] | `1,399.68` | `71.35` | `1.61x` |
|| [Hasura] | `869.69` | `114.81` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,637.00` | `1.07` | `25.83x` |
|| [Tailcall] | `59,557.80` | `1.69` | `22.75x` |
|| [Gqlgen] | `47,525.20` | `5.21` | `18.15x` |
|| [async-graphql] | `47,150.60` | `2.21` | `18.01x` |
|| [Netflix DGS] | `8,261.44` | `15.02` | `3.16x` |
|| [Apollo GraphQL] | `8,186.12` | `12.54` | `3.13x` |
|| [GraphQL JIT] | `5,273.45` | `18.93` | `2.01x` |
|| [Hasura] | `2,618.18` | `38.13` | `1.00x` |

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
