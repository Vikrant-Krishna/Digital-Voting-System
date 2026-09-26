require('dotenv').config();
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost', user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '', database: process.env.DB_NAME || 'VotingDB',
  port: Number(process.env.DB_PORT || 3306),
  // Set DB_SSL=true for managed MySQL services that require TLS.
  ssl: process.env.DB_SSL === 'true' ? {} : undefined,
  waitForConnections: true, connectionLimit: 5, enableKeepAlive: true, dateStrings: true
});
module.exports = pool;
