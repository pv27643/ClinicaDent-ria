const { sequelize } = require('./index');
const { QueryTypes } = require('sequelize');

exports.getAll = async () => {
  const rows = await sequelize.query('SELECT * FROM consulta', { type: QueryTypes.SELECT });
  return rows;
};

exports.getPast = async () => {
  const rows = await sequelize.query("SELECT * FROM consulta WHERE status = 'realizada'", { type: QueryTypes.SELECT });
  return rows;
};

exports.getFuture = async () => {
  const rows = await sequelize.query("SELECT * FROM consulta WHERE status = 'confirmada'", { type: QueryTypes.SELECT });
  return rows;
};
