const express = require('express');

module.exports = function (opts) {
  const { db, authMiddleware } = opts;
  const router = express.Router();

  router.get('/', authMiddleware, async (req, res) => {
    try {
      const { search = '', estado = '', page = 1 } = req.query;
      const limit = 25;
      const offset = (Math.max(1, parseInt(page, 10)) - 1) * limit;
      let base = 'SELECT id, nome_completo, email, telefone, data_nascimento, genero, n_utente, estado FROM pacientes';
      const where = [];
      const params = [];
      if (search) { params.push(`%${search}%`); where.push(`(nome_completo ILIKE $${params.length} OR email ILIKE $${params.length})`); }
      if (estado) { params.push(estado); where.push(`estado=$${params.length}`); }
      if (where.length) base += ' WHERE ' + where.join(' AND ');
      params.push(limit); params.push(offset);
      base += ` ORDER BY nome_completo LIMIT $${params.length-1} OFFSET $${params.length}`;
      const r = await db.query(base, params);
      res.json(r.rows.map(u => ({ id: u.id, nomeCompleto: u.nome_completo, email: u.email, telefone: u.telefone, dataNascimento: u.data_nascimento, genero: u.genero, nUtente: u.n_utente, estado: u.estado })));
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro a listar pacientes', error: err.message });
    }
  });

  router.get('/:id', authMiddleware, async (req, res) => {
    try {
      const { id } = req.params;
      const r = await db.query('SELECT id, nome_completo, email, telefone, data_nascimento, genero, n_utente, morada, notas FROM pacientes WHERE id=$1 LIMIT 1', [id]);
      const p = r.rows[0];
      if (!p) return res.status(404).json({ message: 'Paciente não encontrado' });
      res.json({ id: p.id, nomeCompleto: p.nome_completo, email: p.email, telefone: p.telefone, dataNascimento: p.data_nascimento, genero: p.genero, nUtente: p.n_utente, morada: p.morada, notas: p.notas, dependentes: [], historicoResumo: [] });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro a obter paciente', error: err.message });
    }
  });

  router.post('/', authMiddleware, async (req, res) => {
    try {
      const { nomeCompleto, email, telefone, dataNascimento, genero, nUtente, morada, seguroPrincipalId } = req.body;
      const q = 'INSERT INTO pacientes(nome_completo, email, telefone, data_nascimento, genero, n_utente, morada, seguro_principal_id, estado) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id';
      const r = await db.query(q, [nomeCompleto, email || null, telefone || null, dataNascimento || null, genero || null, nUtente || null, morada || null, seguroPrincipalId || null, 'Ativo']);
      res.status(201).json({ id: r.rows[0].id });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro a criar paciente', error: err.message });
    }
  });

  router.put('/:id', authMiddleware, async (req, res) => {
    try {
      const { id } = req.params;
      const { nomeCompleto, email, telefone, dataNascimento, genero, nUtente, morada, seguroPrincipalId } = req.body;
      const q = 'UPDATE pacientes SET nome_completo=$1, email=$2, telefone=$3, data_nascimento=$4, genero=$5, n_utente=$6, morada=$7, seguro_principal_id=$8 WHERE id=$9 RETURNING id';
      const r = await db.query(q, [nomeCompleto, email || null, telefone || null, dataNascimento || null, genero || null, nUtente || null, morada || null, seguroPrincipalId || null, id]);
      if (!r.rows.length) return res.status(404).json({ message: 'Paciente não encontrado' });
      res.json({ id: r.rows[0].id });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro a atualizar paciente', error: err.message });
    }
  });

  router.delete('/:id', authMiddleware, async (req, res) => {
    try {
      const { id } = req.params;
      await db.query('DELETE FROM pacientes WHERE id=$1', [id]);
      res.json({ message: 'Paciente eliminado' });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: 'Erro a eliminar paciente', error: err.message });
    }
  });

  return router;
};
