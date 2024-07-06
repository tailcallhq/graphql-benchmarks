const express = require('express');
const app = express();
const port = 4000;

app.use(express.json());

app.post('/greet', (req, res) => {
  res.json('Hello World!');
});

app.listen(port, () => {
  console.log(`Greet action handler running on port ${port}`);
});
