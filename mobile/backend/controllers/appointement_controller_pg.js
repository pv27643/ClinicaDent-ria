const appointmentsModel = require('../models/appointement');

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
