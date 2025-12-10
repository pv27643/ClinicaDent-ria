const db = require('./db_sqlite');

exports.getAll = async () => {
  const rows = await db.all('SELECT * FROM consulta');
  return rows;
};

exports.getPast = async () => {
  const rows = await db.all("SELECT * FROM consulta WHERE status = 'realizada'");
  return rows;
};

exports.getFuture = async () => {
  const rows = await db.all("SELECT * FROM consulta WHERE status = 'confirmada'");
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
  } = data || {};

  // Normalize data_consulta to ISO string if it's a Date
  let dataConsultaVal = data_consulta;
  if (dataConsultaVal instanceof Date) {
    dataConsultaVal = dataConsultaVal.toISOString();
  } else if (dataConsultaVal && typeof dataConsultaVal === 'object' && dataConsultaVal.toISOString) {
    dataConsultaVal = dataConsultaVal.toISOString();
  } else if (dataConsultaVal) {
    dataConsultaVal = String(dataConsultaVal);
  } else {
    dataConsultaVal = null;
  }

  // Build insert allowing optional id
  if (id !== undefined && id !== null) {
    const sql = `INSERT INTO consulta (id, id_medico, hora, tipo_de_marcacao, status, data_consulta) VALUES (?, ?, ?, ?, ?, ?)`;
    await db.run(sql, [id, id_medico, hora, tipo_de_marcacao, status, dataConsultaVal]);
    const row = await db.get('SELECT * FROM consulta WHERE id = ?', [id]);
    return row;
  } else {
    const sql = `INSERT INTO consulta (id_medico, hora, tipo_de_marcacao, status, data_consulta) VALUES (?, ?, ?, ?, ?)`;
    const result = await db.run(sql, [id_medico, hora, tipo_de_marcacao, status, dataConsultaVal]);
    const lastID = result.lastID;
    const row = await db.get('SELECT * FROM consulta WHERE id = ?', [lastID]);
    return row;
  }
};
