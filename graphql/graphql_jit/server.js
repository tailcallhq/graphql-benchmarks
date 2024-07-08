const express = require('express');
const { buildSchema, parse, execute } = require('graphql');
const { compileQuery } = require('graphql-jit');
const bodyParser = require('body-parser');

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
    users: [User]
    post(id: Int!): Post
    user(id: Int!): User
  }
`);

const fetchData = async (url) => {
  const fetch = (await import('node-fetch')).default;
  const response = await fetch(url);
  return await response.json();
};

const root = {
  greet: () => 'Hello World!',
  posts: async () => {
    const posts = await fetchData('https://jsonplaceholder.typicode.com/posts');
    const users = await fetchData('https://jsonplaceholder.typicode.com/users');
    const usersMap = users.reduce((acc, user) => {
      acc[user.id] = user;
      return acc;
    }, {});
    return posts.map(post => ({
      ...post,
      user: usersMap[post.userId]
    }));
  },
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

    const result = await execute({
      schema,
      document,
      rootValue: root,
      contextValue: null,
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

app.listen(8000, () => {
  console.log('Running a GraphQL API server at http://localhost:8000/graphql');
});
