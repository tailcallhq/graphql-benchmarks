<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
|| [Netflix DGS] | `0.00` | `0.00` | `x` |
|| [Hasura] | `0.00` | `0.00` | `x` |
|| [GraphQL JIT] | `0.00` | `0.00` | `x` |
|| [Gqlgen] | `0.00` | `0.00` | `x` |
|| [Caliban] | `0.00` | `0.00` | `x` |
|| [async-graphql] | `0.00` | `0.00` | `x` |
|| [Apollo GraphQL] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
|| [Netflix DGS] | `0.00` | `0.00` | `x` |
|| [Hasura] | `0.00` | `0.00` | `x` |
|| [GraphQL JIT] | `0.00` | `0.00` | `x` |
|| [Gqlgen] | `0.00` | `0.00` | `x` |
|| [Caliban] | `0.00` | `0.00` | `x` |
|| [async-graphql] | `0.00` | `0.00` | `x` |
|| [Apollo GraphQL] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
|| [Netflix DGS] | `0.00` | `0.00` | `x` |
|| [Hasura] | `0.00` | `0.00` | `x` |
|| [GraphQL JIT] | `0.00` | `0.00` | `x` |
|| [Gqlgen] | `0.00` | `0.00` | `x` |
|| [Caliban] | `0.00` | `0.00` | `x` |
|| [async-graphql] | `0.00` | `0.00` | `x` |
|| [Apollo GraphQL] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
