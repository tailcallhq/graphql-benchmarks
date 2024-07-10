

Query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{posts{id,userId,title,user{id,name,email}}}"
    }
    `

| Server         | Requests/sec | Latency (ms) | Relative |
| -------------- | ------------ | ------------ | -------- |
| Tailcall       | `89,291.15`  | `1.13`       | `41.99x` |
| Netflix DGS    | `56,825.47`  | `0.00`       | `26.73x` |
| Apollo GraphQL | `56,134.52`  | `0.00`       | `26.40x` |
| async-graphql  | `37,721.58`  | `2.65`       | `17.74x` |
| Gqlgen         | `35,032.42`  | `2.85`       | `16.48x` |
| Caliban        | `29,028.39`  | `5.59`       | `13.65x` |
| GraphQL JIT    | `4,325.73`   | `23.14`      | `2.03x`  |
| Hasura         | `2,126.24`   | `47.24`      | `1.00x`  |

Query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{posts{title}}"
    }
    `

| Server         | Requests/sec | Latency (ms) | Relative |
| -------------- | ------------ | ------------ | -------- |
| Tailcall       | `95,058.09`  | `1.05`       | `31.29x` |
| Apollo GraphQL | `57,698.88`  | `0.00`       | `18.99x` |
| Netflix DGS    | `57,434.55`  | `0.00`       | `18.91x` |
| async-graphql  | `38,962.58`  | `2.56`       | `12.83x` |
| Gqlgen         | `34,854.01`  | `2.87`       | `11.47x` |
| Caliban        | `31,380.15`  | `3.19`       | `10.33x` |
| GraphQL JIT    | `4,416.48`   | `22.65`      | `1.45x`  |
| Hasura         | `3,037.81`   | `32.93`      | `1.00x`  |

Query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{greet}"
    }
    `

| Server         | Requests/sec | Latency (ms) | Relative |
| -------------- | ------------ | ------------ | -------- |
| async-graphql  | `109,626.13` | `0.91`       | `25.15x` |
| Tailcall       | `102,125.18` | `0.98`       | `23.43x` |
| Caliban        | `101,194.55` | `0.98`       | `23.22x` |
| Gqlgen         | `78,166.85`  | `1.28`       | `17.94x` |
| Netflix DGS    | `56,970.59`  | `0.00`       | `13.07x` |
| Apollo GraphQL | `54,844.17`  | `0.00`       | `12.58x` |
| GraphQL JIT    | `14,623.61`  | `6.84`       | `3.36x`  |
| Hasura         | `4,358.08`   | `23.00`      | `1.00x`  |
