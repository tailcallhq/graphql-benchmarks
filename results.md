<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,075.30` | `92.47` | `x` |
|| [async-graphql] | `1,059.72` | `93.84` | `x` |
|| [Caliban] | `875.13` | `114.51` | `x` |
|| [Gqlgen] | `392.46` | `251.40` | `x` |
|| [Netflix DGS] | `190.62` | `521.11` | `x` |
|| [Apollo GraphQL] | `124.69` | `728.09` | `x` |
|| [Hasura] | `117.50` | `765.28` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,566.02` | `18.03` | `x` |
|| [async-graphql] | `5,264.75` | `18.99` | `x` |
|| [GraphQL JIT] | `1,125.53` | `88.67` | `x` |
|| [Gqlgen] | `1,098.04` | `99.92` | `x` |
|| [Apollo GraphQL] | `839.73` | `119.55` | `x` |
|| [Netflix DGS] | `819.10` | `151.77` | `x` |
|| [Hasura] | `419.16` | `239.86` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `47,146.60` | `2.06` | `x` |
|| [Gqlgen] | `24,837.10` | `5.10` | `x` |
|| [async-graphql] | `24,415.70` | `4.09` | `x` |
|| [GraphQL JIT] | `4,525.89` | `22.01` | `x` |
|| [Netflix DGS] | `4,208.82` | `28.61` | `x` |
|| [Apollo GraphQL] | `3,828.18` | `29.96` | `x` |
|| [Hasura] | `1,594.58` | `64.39` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
