const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/loginById', authController.loginById);

module.exports = router;
