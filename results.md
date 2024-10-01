<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [GraphQL JIT] | `1,086.81` | `91.48` | `x` |
|| [async-graphql] | `1,079.32` | `92.11` | `x` |
|| [Caliban] | `883.46` | `112.88` | `x` |
|| [Gqlgen] | `400.02` | `246.60` | `x` |
|| [Netflix DGS] | `188.89` | `519.06` | `x` |
|| [Apollo GraphQL] | `125.26` | `726.58` | `x` |
|| [Hasura] | `115.90` | `774.12` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 2 | `{ posts { title }}` |
|| [Caliban] | `5,658.83` | `17.73` | `x` |
|| [async-graphql] | `5,295.24` | `18.89` | `x` |
|| [GraphQL JIT] | `1,125.86` | `88.57` | `x` |
|| [Gqlgen] | `1,119.15` | `98.09` | `x` |
|| [Apollo GraphQL] | `867.14` | `115.80` | `x` |
|| [Netflix DGS] | `816.15` | `157.29` | `x` |
|| [Hasura] | `473.38` | `213.40` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |
| 3 | `{ greet }` |
|| [Caliban] | `46,678.90` | `2.08` | `x` |
|| [Gqlgen] | `25,588.20` | `5.04` | `x` |
|| [async-graphql] | `25,539.30` | `3.90` | `x` |
|| [GraphQL JIT] | `4,555.71` | `21.90` | `x` |
|| [Netflix DGS] | `4,201.54` | `28.80` | `x` |
|| [Apollo GraphQL] | `3,919.15` | `29.48` | `x` |
|| [Hasura] | `1,620.70` | `64.15` | `x` |
|| [Tailcall] | `0.00` | `0.00` | `x` |

<!-- PERFORMANCE_RESULTS_END -->
