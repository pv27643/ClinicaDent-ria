const pool = require('./db_pg');

exports.auth = async (email, password) => {
  if (typeof email !== 'string' || typeof password !== 'string') return null;

  const emailCol = 'email';
  const passCol = 'senha';
  const table = 'utilizador';

  const sql = `SELECT * FROM ${table} WHERE ${emailCol} = $1 AND ${passCol} = $2 LIMIT 1`;
  try {
    const res = await pool.query(sql, [email, password]);
    if (res && res.rows && res.rows.length > 0) {
      const row = res.rows[0];
      if ((Object.prototype.hasOwnProperty.call(row, 'status') && row.status !== 'utilizador') ||
          (Object.prototype.hasOwnProperty.call(row, 'tipo') && row.tipo !== 'utilizador')) {
        return null;
      }

      return {
        id: row.id ?? null,
        email: row[emailCol] ?? null,
        name: row.name ?? row.nome ?? null,
        raw: row,
      };
    }
  } catch (err) {
  }

  return null;
};

