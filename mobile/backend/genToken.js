const crypto = require('crypto');

module.exports = function genToken(size = 48) {
  return crypto.randomBytes(size).toString('hex');
};
