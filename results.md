<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `7,766.21` | `12.86` | `63.96x` |
|| [GraphQL JIT] | `1,143.11` | `86.98` | `9.41x` |
|| [async-graphql] | `1,011.95` | `98.75` | `8.33x` |
|| [Caliban] | `769.96` | `130.02` | `6.34x` |
|| [Gqlgen] | `399.93` | `246.38` | `3.29x` |
|| [Netflix DGS] | `185.96` | `521.37` | `1.53x` |
|| [Apollo GraphQL] | `131.19` | `699.08` | `1.08x` |
|| [Hasura] | `121.43` | `763.77` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `14,407.80` | `6.98` | `31.49x` |
|| [async-graphql] | `5,238.40` | `19.12` | `11.45x` |
|| [Caliban] | `4,761.33` | `21.53` | `10.41x` |
|| [GraphQL JIT] | `1,187.43` | `84.02` | `2.60x` |
|| [Gqlgen] | `1,124.00` | `97.67` | `2.46x` |
|| [Apollo GraphQL] | `885.37` | `113.37` | `1.94x` |
|| [Netflix DGS] | `801.74` | `125.37` | `1.75x` |
|| [Hasura] | `457.55` | `238.45` | `1.00x` |
| 3 | `{ greet }` |
|| [Caliban] | `32,877.30` | `3.03` | `20.61x` |
|| [Gqlgen] | `24,799.50` | `9.09` | `15.54x` |
|| [async-graphql] | `24,145.10` | `4.14` | `15.13x` |
|| [Tailcall] | `20,696.40` | `4.85` | `12.97x` |
|| [GraphQL JIT] | `4,626.07` | `21.56` | `2.90x` |
|| [Netflix DGS] | `4,187.50` | `27.89` | `2.62x` |
|| [Apollo GraphQL] | `3,968.37` | `28.13` | `2.49x` |
|| [Hasura] | `1,595.47` | `63.07` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
