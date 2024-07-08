const express = require('express');
const { parse } = require('graphql');
const { compileQuery, isCompiledQuery } = require('graphql-jit');
const bodyParser = require('body-parser');
const axios = require('axios');
const DataLoader = require('dataloader');
const { Agent } = require('http');
const { makeExecutableSchema } = require('@graphql-tools/schema');

const httpAgent = new Agent({ keepAlive: true });
const axiosInstance = axios.create({
  httpAgent,
  proxy: {
    protocol: 'http',
    host: '127.0.0.1',
    port: 3000,
  }
});

const typeDefs = `
  type Post {
    userId: Int
    id: Int
    title: String
    body: String
    user: User
  }

  type User {
    id: Int
    name: String
    username: String
    email: String
    phone: String
    website: String
  }

  type Query {
    greet: String
    posts: [Post]
  }
`;

const resolvers = {
  Query: {
    greet: () => 'Hello World!',
    posts: async () => {
      try {
        const response = await axiosInstance.get('http://jsonplaceholder.typicode.com/posts');
        return response.data;
      } catch (error) {
        throw new Error('Failed to fetch posts');
      }
    },
  },
};

const schema = makeExecutableSchema({ typeDefs, resolvers });

async function batchUsers(userIds) {
  const requests = userIds.map(async (id) => {
    const response = await axiosInstance.get(`http://jsonplaceholder.typicode.com/users/${id}`);
    return response.data;
  });
  return await Promise.all(requests);
}

const app = express();

app.use(bodyParser.json());

// In-memory store for compiled queries
const queryCache = new Map();

app.use('/graphql', async (req, res) => {
  const query = req.body.query || req.query.query;
  if (!query) {
    res.status(400).send('Query not provided');
    return;
  }

  try {
    let compiledQuery;
    if (queryCache.has(query)) {
      compiledQuery = queryCache.get(query);
    } else {
      const document = parse(query);
      compiledQuery = compileQuery(schema, document);
      if (!isCompiledQuery(compiledQuery)) {
        throw new Error('Error compiling query');
      }
      queryCache.set(query, compiledQuery);
    }

    const userLoader = new DataLoader(batchUsers, {
      batchScheduleFn: callback => setTimeout(callback, 1),
    });

    const contextValue = { userLoader };

    const result = await compiledQuery.query(
      undefined,
      contextValue,
      req.body.variables,
      req.body.operationName
    );

    res.json(result);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.listen(8000, () => {
  console.log('Running a GraphQL API server at http://localhost:8000/graphql');
});
