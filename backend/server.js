const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

// 测试接口：验证后端是否运行
app.get('/', (req, res) => {
  res.json({ message: 'Backend is running on Railway!' });
});

// 数据库连接（必须放在前面）
const pool = require('./config/db');

// 测试数据库是否连通
app.get('/test-db', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json({
      status: "success",
      message: "数据库连接成功 ✅",
      data: rows
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "数据库连接失败 ❌",
      error: error.message
    });
  }
});

// 端口必须用 process.env.PORT，Railway 自动分配
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});