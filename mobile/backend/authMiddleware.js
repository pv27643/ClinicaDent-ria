const jwt = require('jsonwebtoken');

module.exports = function (JWT_SECRET) {
  return function authMiddleware(req, res, next) {
    const auth = req.headers.authorization;
    if (!auth) return res.status(401).json({ message: 'Token não fornecido' });
    const parts = auth.split(' ');
    if (parts.length !== 2) return res.status(401).json({ message: 'Header Authorization inválido' });
    const token = parts[1];
    try {
      const payload = jwt.verify(token, JWT_SECRET);
      req.user = payload;
      next();
    } catch (err) {
      return res.status(401).json({ message: 'Token inválido' });
    }
  };
};
