
import express from 'express';
const app = express();

// Middleware to parse JSON request bodies
app.use(express.json());

// POST endpoint handler
app.post('/api', (req, res) => {
  const { body: requestBody } = req;
  res.json({
    message: 'Request received',
    data: requestBody
  });
});

// Start server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
