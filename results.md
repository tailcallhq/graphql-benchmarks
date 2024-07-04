<!-- PERFORMANCE_RESULTS_START -->

| Query | Server | Requests/sec | Latency (ms) | Relative |
|-------:|--------:|--------------:|--------------:|---------:|
| 1 | `{ posts { id userId title user { id name email }}}` |
|| [Tailcall] | `30,082.30` | `3.31` | `102.84x` |
|| [Hasura] | `4,459.81` | `22.46` | `15.25x` |
|| [Caliban] | `1,559.81` | `64.13` | `5.33x` |
|| [async-graphql] | `1,492.66` | `66.89` | `5.10x` |
|| [Gqlgen] | `652.24` | `154.11` | `2.23x` |
|| [Netflix DGS] | `365.29` | `212.65` | `1.25x` |
|| [Apollo GraphQL] | `292.51` | `339.55` | `1.00x` |
| 2 | `{ posts { title }}` |
|| [Tailcall] | `62,286.10` | `1.59` | `39.07x` |
|| [Caliban] | `9,266.85` | `11.16` | `5.81x` |
|| [async-graphql] | `7,456.22` | `13.42` | `4.68x` |
|| [Hasura] | `2,474.23` | `40.33` | `1.55x` |
|| [Gqlgen] | `2,216.15` | `46.14` | `1.39x` |
|| [Apollo GraphQL] | `1,745.35` | `57.17` | `1.09x` |
|| [Netflix DGS] | `1,594.40` | `68.48` | `1.00x` |

<!-- PERFORMANCE_RESULTS_END -->
