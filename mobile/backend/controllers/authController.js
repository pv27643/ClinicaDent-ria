const { auth } = require('../models/Auth');

exports.loginById = async (req, res) => {
	try {
		const { email, password } = req.body || {};

		if (!email || !password) {
			return res.status(400).json({ success: false, message: 'email e senha são obrigatórios' });
		}

		// Authenticate only users that are 'utilizador'
		const user = await auth(email, password);

		if (!user) {
			return res.status(401).json({ success: false, message: 'Credenciais inválidas ou não autorizado' });
		}

		return res.json({ success: true, user });
	} catch (err) {
		console.error('AuthController.loginById error:', err);
		return res.status(500).json({ success: false, message: 'Erro interno' });
	}
};
