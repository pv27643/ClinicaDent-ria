const crypto = require('crypto');
const jwt = require('jsonwebtoken');

module.exports = function (db, JWT_SECRET, ACCESS_TOKEN_EXPIRES) {
  function genToken(size = 48) {
    return crypto.randomBytes(size).toString('hex');
  }

  async function createAccessToken(user) {
    return jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: ACCESS_TOKEN_EXPIRES });
  }

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

  return { genToken, createAccessToken, saveRefreshToken, removeRefreshToken, findRefreshToken };
};
