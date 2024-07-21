const express = require("express");
const axios = require("axios");
const DataLoader = require("dataloader");
const { Agent } = require("http");

// Create a new axios instance with connection pooling.
const httpAgent = new Agent({ keepAlive: true });
const axiosInstance = axios.create({
  httpAgent,
});

const app = express();
const port = 4000;

app.use(express.json());

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
      },
    );
    return response.data;
  });
  return await Promise.all(requests);
}

// Route to greet
app.post('/greet', (req, res) => {
  res.json('Hello World!');
});

// Route to fetch posts
app.post('/posts', async (req, res) => {
  try {
    const response = await axiosInstance.get('http://jsonplaceholder.typicode.com/posts', {
      proxy: {
        protocol: "http",
        host: "127.0.0.1",
        port: 3000,
      },
    });
    let posts = response.data;

    if (req.body.request_query.includes("user")) {
      const userLoader = new DataLoader(batchUsers, {
        batchScheduleFn: (callback) => setTimeout(callback, 1),
      });
      posts = await Promise.all(posts.map(async (post) => {
        const user = await userLoader.load(post.userId);
        return {
          ...post,
          user,
        };
      }))
    }

    res.json(posts);
  } catch (error) {
    res.json(error);
  }
});

app.listen(port, () => {
  console.log(`Handler server running on port ${port}`);
});
