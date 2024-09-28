<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,098.21` | `90.59` | `x` |
|| [async-graphql] | `1,051.48` | `94.46` | `x` |
|| [Caliban] | `842.75` | `118.95` | `x` |
|| [Gqlgen] | `404.24` | `244.06` | `x` |
|| [Netflix DGS] | `187.21` | `527.73` | `x` |
|| [Apollo GraphQL] | `125.36` | `726.07` | `x` |
|| [Hasura] | `110.08` | `822.94` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,433.56` | `18.51` | `x` |
|| [async-graphql] | `5,290.53` | `18.89` | `x` |
|| [GraphQL JIT] | `1,158.36` | `86.16` | `x` |
|| [Gqlgen] | `1,131.80` | `97.04` | `x` |
|| [Apollo GraphQL] | `865.49` | `116.10` | `x` |
|| [Netflix DGS] | `792.57` | `160.82` | `x` |
|| [Hasura] | `454.63` | `219.13` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,713.50` | `2.03` | `x` |
|| [Gqlgen] | `26,214.90` | `4.97` | `x` |
|| [async-graphql] | `25,577.10` | `3.90` | `x` |
|| [GraphQL JIT] | `4,526.28` | `22.05` | `x` |
|| [Netflix DGS] | `4,113.40` | `27.37` | `x` |
|| [Apollo GraphQL] | `3,937.24` | `29.13` | `x` |
|| [Hasura] | `1,530.39` | `65.42` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
