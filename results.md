<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,778.30` | `3.24` | `104.49x` |
|| [Caliban] | `1,588.49` | `62.83` | `5.39x` |
|| [async-graphql] | `1,526.31` | `65.42` | `5.18x` |
|| [Hasura] | `1,519.12` | `65.78` | `5.16x` |
|| [Gqlgen] | `672.31` | `149.43` | `2.28x` |
|| [Netflix DGS] | `367.40` | `170.72` | `1.25x` |
|| [Apollo GraphQL] | `294.57` | `337.42` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,800.60` | `1.58` | `39.35x` |
|| [Caliban] | `9,501.39` | `10.82` | `5.95x` |
|| [async-graphql] | `7,550.50` | `13.25` | `4.73x` |
|| [Hasura] | `2,563.07` | `38.93` | `1.61x` |
|| [Gqlgen] | `2,285.80` | `44.70` | `1.43x` |
|| [Apollo GraphQL] | `1,786.35` | `55.73` | `1.12x` |
|| [Netflix DGS] | `1,595.81` | `67.92` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
