// Import express and cors
const express = require('express');
const cors = require('cors');

// Create the app
const app = express();
const PORT = 3000;

// Middleware
app.use(cors()); // allows mobile app to access backend
app.use(express.json()); // parse JSON bodies sent from the frontend

// In-memory storage for tasks
let todos = [];

// API: Get all tasks
app.get('/api/todos', (req, res) => {
  res.json(todos); // send the list of todos as JSON
});

// API: Add a new task
app.post('/api/todos', (req, res) => {
  const { task } = req.body;
  if (task) {
    todos.push({ id: Date.now(), task }); // store task with a unique id
    res.status(201).json({ message: 'Task added successfully' });
  } else {
    res.status(400).json({ error: 'Task is required' });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
