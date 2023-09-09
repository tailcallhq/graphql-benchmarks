import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';
import axios from 'axios';

const typeDefs = `#graphql
  
  type User {
		id: Int!
		name: String!
		username: String!
		email: String!
		phone: String
		website: String
	}

	type Post {
		id: Int!
		userId: Int!
		title: String!
		body: String!
		user: User
	}

  type Query {
		posts: [Post]
  }
`;

const resolvers = {
  Query: {
    posts: async () => {
      try {
        const response = await axios.get('http://jsonplaceholder.typicode.com/posts',
				{
					proxy: {
							protocol: 'http',
							host: 'localhost',
							port: 8080,
					},
				});
        return response.data;
      } catch (error) {
        throw new Error('Failed to fetch posts');
      }
    },
  },
};

const server = new ApolloServer({typeDefs, resolvers});

const { url } = await startStandaloneServer(server, {
  listen: { port: 8000 },
});

console.log(`🚀  Server ready at: ${url}`);
