const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',        // your DB username
  host: '127.0.0.1',       // DB host
  database: 'bd_abd',      // your DB name
  password: 'Abcd2425',    // your DB password
  port: 5432,              // default PostgreSQL port
});

pool.connect()
  .then(() => console.log('PostgreSQL connected'))
  .catch(err => console.error('Connection error', err));

module.exports = pool;
