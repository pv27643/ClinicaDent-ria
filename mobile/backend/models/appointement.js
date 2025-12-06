const pool = require('./db_pg');

exports.getAll = async () => {
  const result = await pool.query('SELECT * FROM consulta');
  return result.rows;
};
