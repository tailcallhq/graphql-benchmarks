<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [async-graphql] | `1,996.14` | `50.15` | `x` |
|| [Caliban] | `1,631.26` | `61.21` | `x` |
|| [GraphQL JIT] | `1,340.67` | `74.31` | `x` |
|| [Gqlgen] | `794.39` | `124.86` | `x` |
|| [Netflix DGS] | `367.86` | `195.03` | `x` |
|| [Apollo GraphQL] | `272.81` | `359.70` | `x` |
|| [Hasura] | `148.86` | `492.58` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [async-graphql] | `9,523.34` | `10.54` | `x` |
|| [Caliban] | `9,448.42` | `10.97` | `x` |
|| [Gqlgen] | `2,191.93` | `47.21` | `x` |
|| [Apollo GraphQL] | `1,769.01` | `56.44` | `x` |
|| [Netflix DGS] | `1,614.54` | `69.74` | `x` |
|| [GraphQL JIT] | `1,399.62` | `71.34` | `x` |
|| [Hasura] | `868.81` | `114.82` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `67,837.10` | `1.06` | `x` |
|| [async-graphql] | `47,864.90` | `2.13` | `x` |
|| [Gqlgen] | `47,727.30` | `4.97` | `x` |
|| [Netflix DGS] | `8,307.45` | `14.58` | `x` |
|| [Apollo GraphQL] | `8,078.59` | `12.54` | `x` |
|| [GraphQL JIT] | `5,133.58` | `19.45` | `x` |
|| [Hasura] | `2,676.19` | `37.39` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
