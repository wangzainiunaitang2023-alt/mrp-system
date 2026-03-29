
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Backend is running' });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
const pool = require('./config/db');

app.get('/test-db', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});