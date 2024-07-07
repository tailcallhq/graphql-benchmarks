<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,776.30` | `3.24` | `103.70x` |
|| [Caliban] | `1,626.47` | `61.40` | `5.48x` |
|| [async-graphql] | `1,548.25` | `64.49` | `5.22x` |
|| [Hasura] | `1,520.21` | `65.72` | `5.12x` |
|| [Gqlgen] | `665.02` | `150.95` | `2.24x` |
|| [Netflix DGS] | `370.71` | `215.15` | `1.25x` |
|| [Apollo GraphQL] | `296.79` | `334.89` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,777.40` | `1.58` | `38.89x` |
|| [Caliban] | `9,390.87` | `10.96` | `5.82x` |
|| [async-graphql] | `7,747.21` | `12.91` | `4.80x` |
|| [Hasura] | `2,609.93` | `38.23` | `1.62x` |
|| [Gqlgen] | `2,266.09` | `45.08` | `1.40x` |
|| [Apollo GraphQL] | `1,794.21` | `55.57` | `1.11x` |
|| [Netflix DGS] | `1,614.05` | `68.17` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
