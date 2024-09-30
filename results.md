<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [async-graphql] | `1,104.51` | `90.00` | `x` |
|| [GraphQL JIT] | `1,070.23` | `92.95` | `x` |
|| [Caliban] | `950.05` | `105.17` | `x` |
|| [Gqlgen] | `396.39` | `248.83` | `x` |
|| [Netflix DGS] | `189.57` | `517.15` | `x` |
|| [Apollo GraphQL] | `125.89` | `722.56` | `x` |
|| [Hasura] | `112.08` | `772.32` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,765.49` | `17.41` | `x` |
|| [async-graphql] | `5,431.03` | `18.40` | `x` |
|| [GraphQL JIT] | `1,134.85` | `87.97` | `x` |
|| [Gqlgen] | `1,110.98` | `98.86` | `x` |
|| [Apollo GraphQL] | `865.29` | `116.09` | `x` |
|| [Netflix DGS] | `815.84` | `151.23` | `x` |
|| [Hasura] | `416.40` | `246.36` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `49,348.00` | `1.96` | `x` |
|| [async-graphql] | `25,782.90` | `3.86` | `x` |
|| [Gqlgen] | `25,597.50` | `5.00` | `x` |
|| [GraphQL JIT] | `4,389.61` | `22.73` | `x` |
|| [Netflix DGS] | `4,219.72` | `27.80` | `x` |
|| [Apollo GraphQL] | `3,989.83` | `28.49` | `x` |
|| [Hasura] | `1,580.55` | `66.78` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
