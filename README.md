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

[Tailcall]: https://tailcall.run/
[Gqlgen]: https://gqlgen.com/
[Apollo GraphQL]: https://new.apollographql.com/
[Netflix DGS]: https://netflix.github.io/dgs/
[Caliban]: https://ghostdogpr.github.io/caliban/
[async-graphql]: https://github.com/async-graphql/async-graphql

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

### Test Query
```graphql
{
  posts {
    title
  }
}
```

<!-- PERFORMANCE_RESULTS_START_1 -->

| Server | Requests/sec | Latency (ms) |
|--------:|--------------:|--------------:|
| [Tailcall] | `93,342.31` | `1.07` |
| [Caliban] | `25,046.63` | `3.98` |
| [async-graphql] | `18,078.63` | `5.53` |
| [Netflix DGS] | `6,299.71` | `15.82` |
| [Apollo GraphQL] | `6,112.70` | `16.39` |
| [Gqlgen] | `5,966.77` | `16.77` |

<!-- PERFORMANCE_RESULTS_END_1 -->

### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram1.png)

### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram1.png)

---

### Test Query
```graphql
{
  posts {
    id
    userId
    title
    user {
      id
      name
      email
    }
  }
}
```

<!-- PERFORMANCE_RESULTS_START_2 -->

| Server | Requests/sec | Latency (ms) |
|--------:|--------------:|--------------:|
| [Gqlgen] | `57,674.11` | `0.00` |
| [Tailcall] | `54,446.05` | `1.83` |
| [Caliban] | `3,980.10` | `25.21` |
| [async-graphql] | `3,262.37` | `30.67` |
| [Apollo GraphQL] | `1,371.23` | `73.07` |
| [Netflix DGS] | `1,306.06` | `74.16` |

<!-- PERFORMANCE_RESULTS_END_2 -->

### Throughput (Higher is better)

![Throughput Histogram](assets/req_sec_histogram2.png)

### Latency (Lower is better)

![Latency Histogram](assets/latency_histogram2.png)

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
