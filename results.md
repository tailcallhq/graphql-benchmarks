<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,141.34` | `87.17` | `x` |
|| [async-graphql] | `932.56` | `106.55` | `x` |
|| [Caliban] | `897.73` | `111.64` | `x` |
|| [Gqlgen] | `385.36` | `255.92` | `x` |
|| [Netflix DGS] | `185.67` | `526.22` | `x` |
|| [Apollo GraphQL] | `128.91` | `710.66` | `x` |
|| [Hasura] | `116.88` | `774.50` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,598.20` | `17.92` | `x` |
|| [async-graphql] | `4,737.95` | `21.14` | `x` |
|| [GraphQL JIT] | `1,181.85` | `84.46` | `x` |
|| [Gqlgen] | `1,091.66` | `100.78` | `x` |
|| [Apollo GraphQL] | `882.97` | `113.72` | `x` |
|| [Netflix DGS] | `799.35` | `155.70` | `x` |
|| [Hasura] | `435.61` | `238.71` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `48,226.20` | `2.01` | `x` |
|| [Gqlgen] | `25,164.40` | `5.08` | `x` |
|| [async-graphql] | `23,575.70` | `4.23` | `x` |
|| [GraphQL JIT] | `4,520.25` | `22.08` | `x` |
|| [Netflix DGS] | `4,126.01` | `27.85` | `x` |
|| [Apollo GraphQL] | `3,930.50` | `28.95` | `x` |
|| [Hasura] | `1,660.02` | `62.21` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
