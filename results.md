<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,114.24` | `89.25` | `x` |
|| [async-graphql] | `1,076.28` | `92.38` | `x` |
|| [Caliban] | `875.56` | `114.16` | `x` |
|| [Gqlgen] | `396.43` | `248.75` | `x` |
|| [Netflix DGS] | `187.66` | `519.49` | `x` |
|| [Apollo GraphQL] | `129.45` | `706.37` | `x` |
|| [Hasura] | `116.09` | `681.09` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,380.80` | `18.68` | `x` |
|| [async-graphql] | `5,255.50` | `19.06` | `x` |
|| [GraphQL JIT] | `1,169.77` | `85.35` | `x` |
|| [Gqlgen] | `1,114.45` | `98.79` | `x` |
|| [Apollo GraphQL] | `869.19` | `115.54` | `x` |
|| [Netflix DGS] | `809.71` | `157.29` | `x` |
|| [Hasura] | `416.23` | `244.85` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `45,876.50` | `2.12` | `x` |
|| [Gqlgen] | `25,487.30` | `4.96` | `x` |
|| [async-graphql] | `25,209.00` | `3.96` | `x` |
|| [GraphQL JIT] | `4,542.28` | `21.96` | `x` |
|| [Netflix DGS] | `4,179.81` | `27.45` | `x` |
|| [Apollo GraphQL] | `3,937.09` | `29.25` | `x` |
|| [Hasura] | `1,648.45` | `61.76` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
