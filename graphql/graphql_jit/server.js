const express = require('express');
const { buildSchema, parse, execute } = require('graphql');
const { compileQuery } = require('graphql-jit');
const bodyParser = require('body-parser');
const axios = require('axios');
const DataLoader = require('dataloader');
const { Agent } = require('http');

const httpAgent = new Agent({ keepAlive: true });
const axiosInstance = axios.create({
  httpAgent,
  proxy: {
    protocol: 'http',
    host: '127.0.0.1',
    port: 3000,
  }
});

const schema = buildSchema(`
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
`);

async function batchUsers(userIds) {
  const requests = userIds.map(async (id) => {
    const response = await axiosInstance.get(`http://jsonplaceholder.typicode.com/users/${id}`);
    return response.data;
  });
  return await Promise.all(requests);
}

const root = {
  greet: () => 'Hello World!',
  posts: async () => {
    try {
      const response = await axiosInstance.get('http://jsonplaceholder.typicode.com/posts');
      return response.data;
    } catch (error) {
      throw new Error('Failed to fetch posts');
    }
  }
};

const app = express();

app.use(bodyParser.json());

app.use('/graphql', async (req, res) => {
  const query = req.body.query || req.query.query;
  if (!query) {
    res.status(400).send('Query not provided');
    return;
  }

  try {
    const document = parse(query);
    const compiledQuery = compileQuery(schema, document);

    const userLoader = new DataLoader(batchUsers, {
      batchScheduleFn: callback => setTimeout(callback, 1),
    });

    const contextValue = { userLoader };

    const result = await execute({
      schema,
      document,
      rootValue: root,
      contextValue,
      variableValues: req.body.variables,
      operationName: req.body.operationName,
      fieldResolver: undefined,
      typeResolver: undefined,
      execute: compiledQuery.query,
    });

    res.json(result);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

schema.getType('Post').getFields().user.resolve = async (post, _, { userLoader }) => {
  return userLoader.load(post.userId);
};

app.listen(8000, () => {
  console.log('Running a GraphQL API server at http://localhost:8000/graphql');
});
