const appointmentsModel = require('../models/appointement');

exports.getAllAppointments = async (req, res) => {
  try {
    const appointments = await appointmentsModel.getAll();
    res.json(appointments);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
