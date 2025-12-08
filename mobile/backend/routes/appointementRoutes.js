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
		const {
				id,
				id_medico,
				hora,
				tipo_de_marcacao,
				status,
				data_consulta
			} = req.body || {};

		// client should send 'id' for paciente; use it directly
		const effectiveId = id || null;

		if (!id_medico) {
			return res.status(400).json({
				success: false,
				error: 'id_medico é obrigatório'
			});
		}

		if (!data_consulta) {
			return res.status(400).json({
				success: false,
				error: 'data_consulta é obrigatória'
			});
		}

		// Normalizar/validar hora (espera-se formato HH:MM ou HH:MM:SS)
		let horaStr = hora;
		if (horaStr && /^\d{1,2}:\d{2}$/.test(horaStr)) {
			horaStr = horaStr + ':00';
		}

		if (!horaStr) {
			return res.status(400).json({
				success: false,
				error: 'hora é obrigatória'
			});
		}

		// Verificar se a data não está no passado
		const dataConsultaDate = new Date(data_consulta);
		const agora = new Date();
		
		if (dataConsultaDate < agora) {
			return res.status(400).json({
				success: false,
				error: 'A data da consulta não pode ser no passado'
			});
		}

		// associar id_medico para tipo_de_marcacao (especialidade)
		const medicoId = parseInt(id_medico, 10) || null;
		const especialidadeMap = {
			1: 'Implantologia',
			2: 'Diretora Clínica',
			3: 'Medicina Dentária Generalista'
		};
		const tipoResolvido = tipo_de_marcacao || (medicoId ? especialidadeMap[medicoId] : null) || null;

		const consultaData = {
			id: effectiveId || null,
			id_medico: medicoId,
			hora: horaStr,
			tipo_de_marcacao: tipoResolvido,
			status: status || 'pendente',
			data_consulta: dataConsultaDate
		};

		// Criar consulta usando o model
		const result = await appointmentsModel.create(consultaData);

		res.status(201).json({
			success: true,
			message: 'Consulta marcada com sucesso',
			result
		});

	} catch (err) {
		console.error('Error in create handler:', err);
		res.status(500).json({
			success: false,
			error: err.message
		});
	}
});

module.exports = router;
