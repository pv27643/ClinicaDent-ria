const express = require('express');
const router = express.Router();
const appointmentsController = require('../controllers/appointement_controller_pg');

router.get('/getAll', appointmentsController.getAllAppointments);
router.get('/getPast', appointmentsController.getPastAppointments);
router.get('/getFuture', appointmentsController.getFutureAppointments);



module.exports = router;
