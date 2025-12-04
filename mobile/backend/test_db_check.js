// test_db_check.js — verifica conexão ao DB (mock ou real)
require('dotenv').config();
const path = require('path');
const db = require('./db');

(async () => {
  try {
    console.log('pool present?', !!db.pool);
    const r = await db.query('SELECT NOW() as now');
    console.log('query result:', r.rows[0]);
  } catch (err) {
    console.error('DB error:', err && err.message ? err.message : err);
    process.exitCode = 2;
  }
})();
