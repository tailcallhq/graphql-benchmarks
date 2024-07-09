<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `29,926.60` | `3.33` | `105.92x` |
|| [async-graphql] | `1,715.08` | `58.21` | `6.07x` |
|| [Hasura] | `1,578.62` | `63.93` | `5.59x` |
|| [Caliban] | `1,537.04` | `65.07` | `5.44x` |
|| [Gqlgen] | `768.93` | `129.06` | `2.72x` |
|| [Netflix DGS] | `358.03` | `210.26` | `1.27x` |
|| [Apollo GraphQL] | `282.55` | `347.81` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,158.20` | `1.60` | `38.89x` |
|| [Caliban] | `9,116.82` | `11.33` | `5.70x` |
|| [async-graphql] | `8,596.09` | `11.76` | `5.38x` |
|| [Hasura] | `2,486.59` | `40.20` | `1.56x` |
|| [Gqlgen] | `2,176.55` | `47.52` | `1.36x` |
|| [Apollo GraphQL] | `1,723.16` | `57.95` | `1.08x` |
|| [Netflix DGS] | `1,598.26` | `69.40` | `1.00x` |
| 3 | `{ greet }` |
|| [Tailcall] | `64,242.50` | `1.57` | `24.65x` |
|| [async-graphql] | `48,930.60` | `2.05` | `18.78x` |
|| [Gqlgen] | `47,012.10` | `5.12` | `18.04x` |
|| [Caliban] | `44,295.60` | `2.59` | `17.00x` |
|| [Netflix DGS] | `8,184.14` | `15.03` | `3.14x` |
|| [Apollo GraphQL] | `7,965.16` | `12.87` | `3.06x` |
|| [Hasura] | `2,606.15` | `38.40` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
