// db.js — Conexão com PostgreSQL usando variáveis de ambiente
const { Pool } = require('pg');
require('dotenv').config();

const {
  DATABASE_URL,
  DB_HOST,
  DB_PORT,
  DB_NAME,
  DB_USER,
  DB_PASSWORD,
} = process.env;

let pool;
if (DATABASE_URL || DB_HOST) {
  const config = DATABASE_URL
    ? { connectionString: DATABASE_URL }
    : {
        host: DB_HOST || 'localhost',
        port: DB_PORT ? parseInt(DB_PORT, 10) : 5432,
        database: DB_NAME,
        user: DB_USER,
        password: DB_PASSWORD,
      };

  pool = new Pool(config);
  pool.on('error', (err) => {
    console.error('Postgres pool error', err);
  });
} else {
  console.log('Postgres não configurado (nenhuma variável DB encontrada).');
}

async function query(text, params) {
  if (!pool) throw new Error('Pool PostgreSQL não inicializado. Verifique as variáveis de ambiente.');
  const res = await pool.query(text, params);
  return res;
}

module.exports = {
  query,
  pool,
};
