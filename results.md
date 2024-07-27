<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [async-graphql] | `1,993.94` | `50.67` | `x` |
|| [Caliban] | `1,724.05` | `57.72` | `x` |
|| [GraphQL JIT] | `1,342.58` | `74.17` | `x` |
|| [Gqlgen] | `791.00` | `125.40` | `x` |
|| [Netflix DGS] | `368.24` | `169.41` | `x` |
|| [Apollo GraphQL] | `274.41` | `358.22` | `x` |
|| [Hasura] | `130.69` | `560.42` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [async-graphql] | `9,771.15` | `10.51` | `x` |
|| [Caliban] | `9,706.97` | `10.65` | `x` |
|| [Gqlgen] | `2,178.38` | `47.41` | `x` |
|| [Apollo GraphQL] | `1,771.03` | `56.40` | `x` |
|| [Netflix DGS] | `1,602.83` | `69.22` | `x` |
|| [GraphQL JIT] | `1,370.67` | `72.84` | `x` |
|| [Hasura] | `896.74` | `111.29` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,341.20` | `1.07` | `x` |
|| [async-graphql] | `47,886.70` | `2.09` | `x` |
|| [Gqlgen] | `47,636.10` | `5.24` | `x` |
|| [Netflix DGS] | `8,187.02` | `14.71` | `x` |
|| [Apollo GraphQL] | `8,110.76` | `12.57` | `x` |
|| [GraphQL JIT] | `5,177.76` | `19.28` | `x` |
|| [Hasura] | `2,688.97` | `37.11` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
