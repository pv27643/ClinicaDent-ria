module.exports = function (db) {
  async function saveRefreshToken(token, userId, expiresAt) {
    const q = 'INSERT INTO refresh_tokens(token, user_id, expires_at) VALUES($1,$2,$3)';
    await db.query(q, [token, userId, expiresAt]);
  }

  async function removeRefreshToken(token) {
    const q = 'DELETE FROM refresh_tokens WHERE token=$1';
    await db.query(q, [token]);
  }

  async function findRefreshToken(token) {
    const q = 'SELECT token, user_id, expires_at FROM refresh_tokens WHERE token=$1 LIMIT 1';
    const r = await db.query(q, [token]);
    return r.rows[0];
  }

  return { saveRefreshToken, removeRefreshToken, findRefreshToken };
};
