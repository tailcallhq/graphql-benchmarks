<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,143.39` | `87.00` | `x` |
|| [async-graphql] | `1,071.01` | `92.79` | `x` |
|| [Caliban] | `932.26` | `107.27` | `x` |
|| [Gqlgen] | `407.07` | `242.39` | `x` |
|| [Netflix DGS] | `187.69` | `519.79` | `x` |
|| [Apollo GraphQL] | `129.94` | `705.76` | `x` |
|| [Hasura] | `120.42` | `750.60` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,399.14` | `18.61` | `x` |
|| [async-graphql] | `5,309.40` | `18.82` | `x` |
|| [GraphQL JIT] | `1,188.02` | `84.00` | `x` |
|| [Gqlgen] | `1,125.02` | `97.64` | `x` |
|| [Apollo GraphQL] | `880.11` | `114.09` | `x` |
|| [Netflix DGS] | `818.75` | `156.31` | `x` |
|| [Hasura] | `480.97` | `208.73` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,127.50` | `2.06` | `x` |
|| [Gqlgen] | `25,797.50` | `4.87` | `x` |
|| [async-graphql] | `25,242.40` | `3.95` | `x` |
|| [GraphQL JIT] | `4,652.97` | `21.45` | `x` |
|| [Netflix DGS] | `4,146.44` | `28.15` | `x` |
|| [Apollo GraphQL] | `3,972.92` | `29.13` | `x` |
|| [Hasura] | `1,609.39` | `62.95` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
