const pool = require('./db_pg');

exports.getAll = async () => {
  const result = await pool.query('SELECT * FROM consulta');
  return result.rows;
};

exports.getPast = async () => {
  const result = await pool.query("SELECT * FROM consulta WHERE status = 'realizada'");
  return result.rows;
};

exports.getFuture = async () => {
  const result = await pool.query("SELECT * FROM consulta WHERE status = 'confirmada'");
  return result.rows;
};
