<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,586.10` | `3.26` | `104.88x` |
|| [Caliban] | `1,609.23` | `62.06` | `5.52x` |
|| [async-graphql] | `1,538.16` | `64.91` | `5.27x` |
|| [Hasura] | `1,495.44` | `66.80` | `5.13x` |
|| [Gqlgen] | `672.83` | `149.21` | `2.31x` |
|| [Netflix DGS] | `367.72` | `171.23` | `1.26x` |
|| [Apollo GraphQL] | `291.64` | `340.73` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,779.20` | `1.58` | `39.15x` |
|| [Caliban] | `9,264.30` | `11.11` | `5.78x` |
|| [async-graphql] | `7,696.39` | `12.99` | `4.80x` |
|| [Hasura] | `2,558.48` | `39.01` | `1.60x` |
|| [Gqlgen] | `2,277.49` | `44.81` | `1.42x` |
|| [Apollo GraphQL] | `1,755.12` | `56.84` | `1.09x` |
|| [Netflix DGS] | `1,603.73` | `68.83` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
