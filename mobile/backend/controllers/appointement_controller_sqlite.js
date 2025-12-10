const appointmentsModel = require('../models/appointement_sqlite');

exports.getAllAppointments = async (req, res) => {
  try {
    const appointments = await appointmentsModel.getAll();
    res.json(appointments);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getPastAppointments = async (req, res) => {
  try {
    const appointments = await appointmentsModel.getPast();
    res.json(appointments);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getFutureAppointments = async (req, res) => {
  try {
    const appointments = await appointmentsModel.getFuture();
    res.json(appointments);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createAppointment = async (req, res) => {
  try {
    const body = req.body || {};
    body.status = 'pending';
    const result = await appointmentsModel.create(body);
    res.json({ success: true, result });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

module.exports = {
  getAllAppointments: exports.getAllAppointments,
  getPastAppointments: exports.getPastAppointments,
  getFutureAppointments: exports.getFutureAppointments,
  createAppointments: exports.createAppointment,
};
