<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [async-graphql] | `1,938.05` | `52.13` | `x` |
|| [Caliban] | `1,711.44` | `58.10` | `x` |
|| [GraphQL JIT] | `1,330.16` | `74.91` | `x` |
|| [Gqlgen] | `790.94` | `125.49` | `x` |
|| [Netflix DGS] | `370.28` | `167.28` | `x` |
|| [Apollo GraphQL] | `267.99` | `366.32` | `x` |
|| [Hasura] | `109.88` | `564.77` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [async-graphql] | `9,668.16` | `10.44` | `x` |
|| [Caliban] | `9,659.64` | `10.70` | `x` |
|| [Gqlgen] | `2,209.38` | `46.84` | `x` |
|| [Apollo GraphQL] | `1,742.64` | `57.31` | `x` |
|| [Netflix DGS] | `1,614.35` | `69.72` | `x` |
|| [GraphQL JIT] | `1,389.37` | `71.89` | `x` |
|| [Hasura] | `872.06` | `114.43` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `68,756.90` | `1.05` | `x` |
|| [Gqlgen] | `48,165.60` | `5.23` | `x` |
|| [async-graphql] | `47,349.30` | `2.23` | `x` |
|| [Netflix DGS] | `8,340.33` | `14.47` | `x` |
|| [Apollo GraphQL] | `7,991.78` | `12.70` | `x` |
|| [GraphQL JIT] | `4,862.70` | `20.56` | `x` |
|| [Hasura] | `2,654.88` | `37.61` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
