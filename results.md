<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,218.80` | `3.30` | `103.05x` |
|| [async-graphql] | `1,748.72` | `57.43` | `5.96x` |
|| [Caliban] | `1,599.19` | `62.46` | `5.45x` |
|| [Hasura] | `1,536.69` | `65.04` | `5.24x` |
|| [Gqlgen] | `666.73` | `150.68` | `2.27x` |
|| [Netflix DGS] | `364.07` | `185.28` | `1.24x` |
|| [Apollo GraphQL] | `293.23` | `338.73` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `61,796.00` | `1.61` | `38.72x` |
|| [Caliban] | `9,187.63` | `11.25` | `5.76x` |
|| [async-graphql] | `8,696.39` | `11.60` | `5.45x` |
|| [Hasura] | `2,483.88` | `40.17` | `1.56x` |
|| [Gqlgen] | `2,240.57` | `45.69` | `1.40x` |
|| [Apollo GraphQL] | `1,762.58` | `56.64` | `1.10x` |
|| [Netflix DGS] | `1,595.80` | `68.82` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
