<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,086.42` | `91.49` | `x` |
|| [async-graphql] | `883.29` | `112.54` | `x` |
|| [Caliban] | `784.85` | `127.17` | `x` |
|| [Gqlgen] | `404.47` | `243.89` | `x` |
|| [Netflix DGS] | `189.30` | `508.06` | `x` |
|| [Apollo GraphQL] | `131.44` | `696.84` | `x` |
|| [Hasura] | `118.63` | `718.65` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `4,808.90` | `21.30` | `x` |
|| [async-graphql] | `4,741.00` | `21.24` | `x` |
|| [Gqlgen] | `1,130.98` | `96.92` | `x` |
|| [GraphQL JIT] | `1,127.49` | `88.51` | `x` |
|| [Apollo GraphQL] | `891.22` | `112.64` | `x` |
|| [Netflix DGS] | `805.23` | `124.65` | `x` |
|| [Hasura] | `462.39` | `219.75` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `34,239.90` | `2.93` | `x` |
|| [Gqlgen] | `24,307.40` | `8.01` | `x` |
|| [async-graphql] | `23,084.50` | `4.34` | `x` |
|| [GraphQL JIT] | `4,589.18` | `21.74` | `x` |
|| [Netflix DGS] | `4,160.28` | `28.48` | `x` |
|| [Apollo GraphQL] | `4,069.34` | `26.94` | `x` |
|| [Hasura] | `1,523.68` | `65.54` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
