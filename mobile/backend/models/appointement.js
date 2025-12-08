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

exports.create = async (data) => {
  const {
    id,
    id_medico,
    hora,
    tipo_de_marcacao,
    status = 'pendente',
    data_consulta
  } = data;

  // Query SQL para inserir com RETURNING
  const query = `
    INSERT INTO consulta (id, id_medico, hora, tipo_de_marcacao, status, data_consulta)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING *
  `;

  const result = await sequelize.query(query, {
    bind: [id, id_medico, hora, tipo_de_marcacao, status, data_consulta],
    type: QueryTypes.INSERT
  });

  return result[0][0]; // Retorna o primeiro registro inserido
};
