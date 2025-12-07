const express = require('express');
const router = express.Router();
const appointmentsController = require('../controllers/appointement_controller_pg');
const appointmentsModel = require('../models/appointement');

router.get('/getAll', appointmentsController.getAllAppointments);
router.get('/getPast', appointmentsController.getPastAppointments);
router.get('/getFuture', appointmentsController.getFutureAppointments);




// POST / CRIAR CONSULTA
router.post('/create', async (req, res) => {
	try {
		const body = req.body || {};
		const result = await appointmentsModel.create(body);
		res.json({ success: true, result });
	} catch (err) {
		console.error('Error in create handler:', err);
		res.status(500).json({ success: false, error: err.message });
	}
});

module.exports = router;
