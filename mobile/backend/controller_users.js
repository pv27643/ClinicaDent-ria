const express = require('express');

module.exports = function (opts) {
  const { db, authMiddleware } = opts;
  const router = express.Router();

  router.get('/me', authMiddleware, async (req, res) => {
    try {
      const uid = req.user.id;
      const r = await db.query('SELECT id, nome_completo, email, telefone, data_nascimento, genero, n_utente, role FROM usuarios WHERE id=$1 LIMIT 1', [uid]);
      const u = r.rows[0];
      if (!u) return res.status(404).json({ message: 'Usuário não encontrado' });
      res.json({ id: u.id, nomeCompleto: u.nome_completo, email: u.email, telefone: u.telefone, dataNascimento: u.data_nascimento, genero: u.genero, nUtente: u.n_utente, role: u.role });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro ao obter utilizador', error: err.message });
    }
  });

  router.put('/me', authMiddleware, async (req, res) => {
    try {
      const uid = req.user.id;
      const { nomeCompleto, email, telefone, dataNascimento, genero, nUtente } = req.body;
      const q = 'UPDATE usuarios SET nome_completo=$1, email=$2, telefone=$3, data_nascimento=$4, genero=$5, n_utente=$6 WHERE id=$7 RETURNING id, nome_completo, email, telefone, data_nascimento, genero, n_utente, role';
      const r = await db.query(q, [nomeCompleto, email, telefone, dataNacimiento || null, genero || null, nUtente || null, uid]);
      const u = r.rows[0];
      res.json({ user: { id: u.id, nomeCompleto: u.nome_completo, email: u.email, telefone: u.telefone, dataNascimento: u.data_nascimento, genero: u.genero, nUtente: u.n_utente, role: u.role } });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro ao atualizar perfil', error: err.message });
    }
  });

  return router;
};
