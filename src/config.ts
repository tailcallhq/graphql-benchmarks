import { Duration } from "./utils";

const servers = {
  tailcall: "Tailcall",
  gqlgen: "Gqlgen",
  apollo: "Apollo GraphQL",
  netflixdgs: "Netflix DGS",
  caliban: "Caliban",
  async_graphql: "async-graphql",
  hasura: "Hasura",
} as const;

const queries = {
  1: {
    query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{posts{id,userId,title,user{id,name,email}}}"
    }
    `,
    duration: "10s",
  },
  2: {
    query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{posts{title}}"
    }
    `,
    duration: "30s",
  },
  3: {
    query: `
    {
      "operationName": null,
      "variables": {},
      "query": "{greet}"
    }
    `,
    duration: "10s",
  },
} as {
  [key: string]: {
    query: string;
    duration: Duration;
  };
};

export { servers, queries };
