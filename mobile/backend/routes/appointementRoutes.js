const express = require('express');
const router = express.Router();
const appointmentsController = require('../controllers/appointement_controller_pg');

router.get('/getAll', appointmentsController.getAllAppointments);



module.exports = router;
