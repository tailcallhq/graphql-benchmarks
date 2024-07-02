import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import axios from "axios";
import { Agent } from "http";
import DataLoader from "dataloader";

// Create a new axios instance with connection pooling.
const httpAgent = new Agent({ keepAlive: true });
const axiosInstance = axios.create({
  httpAgent,
});

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

async function batchUsers(usersIds) {
  const requests = usersIds.map(async (id) => {
    const response = await axiosInstance.get(
      `http://jsonplaceholder.typicode.com/users/${id}`,
      {
        proxy: {
          protocol: "http",
          host: "127.0.0.1",
          port: 3000,
        },
      }
    );
    return response.data;
  });
  return await Promise.all(requests);
}

const resolvers = {
  Query: {
    posts: async () => {
      try {
        const response = await axiosInstance.get(
          "http://jsonplaceholder.typicode.com/posts",
          {
            proxy: {
              protocol: "http",
              host: "127.0.0.1",
              port: 3000,
            },
          },
        );
        return response.data;
      } catch (error) {
        throw new Error("Failed to fetch posts");
      }
    },
  },
  Post: {
    user: async (post, _, { userLoader }) => {
      return userLoader.load(post.userId);
    },
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

const { url } = await startStandaloneServer(server, {
  context: async () => {
    return {
      userLoader: new DataLoader(batchUsers, {
        batchScheduleFn: callback => setTimeout(callback, 1),
      })
    };
  },
  listen: { port: 8000 },
});

console.log(`🚀  Server ready at: ${url}`);
