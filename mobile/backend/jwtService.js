const jwt = require('jsonwebtoken');

module.exports = function (JWT_SECRET, ACCESS_TOKEN_EXPIRES) {
  async function createAccessToken(user) {
    return jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: ACCESS_TOKEN_EXPIRES });
  }

  return { createAccessToken };
};
