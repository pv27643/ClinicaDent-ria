// backend API usando PostgreSQL
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const db = require('./db');

const PORT = process.env.PORT || 3001;
const JWT_SECRET = process.env.JWT_SECRET || 'change_this_secret';
const ACCESS_TOKEN_EXPIRES = process.env.ACCESS_TOKEN_EXPIRES || '15m';
const REFRESH_TOKEN_EXPIRES_DAYS = parseInt(process.env.REFRESH_TOKEN_EXPIRES_DAYS || '30', 10);

const app = express();
app.use(cors());
app.use(express.json());

function genToken(size = 48) {
  return crypto.randomBytes(size).toString('hex');
}

async function createAccessToken(user) {
  return jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: ACCESS_TOKEN_EXPIRES });
}

async function saveRefreshToken(token, userId, expiresAt) {
  const q = 'INSERT INTO refresh_tokens(token, user_id, expires_at) VALUES($1,$2,$3)';
  await db.query(q, [token, userId, expiresAt]);
}

async function removeRefreshToken(token) {
  const q = 'DELETE FROM refresh_tokens WHERE token=$1';
  await db.query(q, [token]);
}

async function findRefreshToken(token) {
  const q = 'SELECT token, user_id, expires_at FROM refresh_tokens WHERE token=$1 LIMIT 1';
  const r = await db.query(q, [token]);
  return r.rows[0];
}

function authMiddleware(req, res, next) {
  const auth = req.headers.authorization;
  if (!auth) return res.status(401).json({ message: 'Token não fornecido' });
  const parts = auth.split(' ');
  if (parts.length !== 2) return res.status(401).json({ message: 'Header Authorization inválido' });
  const token = parts[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Token inválido' });
  }
}

// --- AUTENTICAÇÃO ---

app.post('/api/auth/register', async (req, res) => {
  try {
    const { nomeCompleto, telefone, email, password, confirmPassword, aceitouTermos } = req.body;
    if (!nomeCompleto || !email || !password || !confirmPassword) return res.status(400).json({ message: 'Campos obrigatórios em falta' });
    if (password !== confirmPassword) return res.status(400).json({ message: 'Passwords não coincidem' });
    if (!aceitouTermos) return res.status(400).json({ message: 'Aceite dos termos obrigatório' });

    const exists = await db.query('SELECT id FROM usuarios WHERE email=$1 LIMIT 1', [email]);
    if (exists.rows.length) return res.status(409).json({ message: 'Email já registado' });

    const hashed = bcrypt.hashSync(password, 10);
    const insert = await db.query(
      'INSERT INTO usuarios(nome_completo, telefone, email, senha, role) VALUES($1,$2,$3,$4,$5) RETURNING id, nome_completo, email',
      [nomeCompleto, telefone || null, email, hashed, 'Paciente']
    );
    const user = insert.rows[0];
    res.status(201).json({ user: { id: user.id, nomeCompleto: user.nome_completo || nomeCompleto, email: user.email } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro no registo', error: err.message });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'email e password são obrigatórios' });
    const r = await db.query('SELECT id, nome_completo, telefone, email, senha, role FROM usuarios WHERE email=$1 LIMIT 1', [email]);
    const user = r.rows[0];
    if (!user) return res.status(401).json({ message: 'Credenciais inválidas' });
    const match = bcrypt.compareSync(password, user.senha);
    if (!match) return res.status(401).json({ message: 'Credenciais inválidas' });

    const accessToken = await createAccessToken(user);
    const refreshToken = genToken(32);
    const expiresAt = new Date(Date.now() + REFRESH_TOKEN_EXPIRES_DAYS * 24 * 60 * 60 * 1000);
    try { await saveRefreshToken(refreshToken, user.id, expiresAt); } catch (e) { console.warn('Could not save refresh token', e.message); }

    res.json({ accessToken, refreshToken, user: { id: user.id, nomeCompleto: user.nome_completo, email: user.email, telefone: user.telefone, role: user.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro no login', error: err.message });
  }
});

app.post('/api/auth/refresh-token', async (req, res) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) return res.status(400).json({ message: 'refreshToken é obrigatório' });
    const row = await findRefreshToken(refreshToken);
    if (!row) return res.status(401).json({ message: 'Refresh token inválido' });
    if (new Date(row.expires_at) < new Date()) {
      await removeRefreshToken(refreshToken);
      return res.status(401).json({ message: 'Refresh token expirado' });
    }
    const ur = await db.query('SELECT id, nome_completo, email, telefone, role FROM usuarios WHERE id=$1 LIMIT 1', [row.user_id]);
    const user = ur.rows[0];
    if (!user) return res.status(401).json({ message: 'Utilizador não encontrado' });
    const accessToken = await createAccessToken(user);
    const newRefresh = genToken(32);
    const expiresAt = new Date(Date.now() + REFRESH_TOKEN_EXPIRES_DAYS * 24 * 60 * 60 * 1000);
    await removeRefreshToken(refreshToken);
    await saveRefreshToken(newRefresh, user.id, expiresAt);
    res.json({ accessToken, refreshToken: newRefresh });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro ao renovar token', error: err.message });
  }
});

app.post('/api/auth/logout', async (req, res) => {
  try {
    const { refreshToken } = req.body;
    if (refreshToken) await removeRefreshToken(refreshToken);
    return res.json({ message: 'Logout efetuado' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro no logout', error: err.message });
  }
});

app.post('/api/auth/forgot-password', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: 'email é obrigatório' });
    const r = await db.query('SELECT id FROM usuarios WHERE email=$1 LIMIT 1', [email]);
    const user = r.rows[0];
    if (!user) return res.json({ message: 'Se o email existir, receberá instruções para redefinir a password' });
    const token = genToken(24);
    const expiresAt = new Date(Date.now() + 1000 * 60 * 60); // 1 hora
    await db.query('INSERT INTO password_resets(user_id, token, expires_at) VALUES($1,$2,$3)', [user.id, token, expiresAt]);
    // Em produção envia email com token; aqui devolvemos apenas mensagem
    return res.json({ message: 'Token de redefinição gerado. Verifica o teu email.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro em forgot-password', error: err.message });
  }
});

app.post('/api/auth/reset-password', async (req, res) => {
  try {
    const { tokenReset, newPassword, confirmPassword } = req.body;
    if (!tokenReset || !newPassword || !confirmPassword) return res.status(400).json({ message: 'Campos obrigatórios em falta' });
    if (newPassword !== confirmPassword) return res.status(400).json({ message: 'Passwords não coincidem' });
    const r = await db.query('SELECT user_id, expires_at FROM password_resets WHERE token=$1 LIMIT 1', [tokenReset]);
    const row = r.rows[0];
    if (!row) return res.status(400).json({ message: 'Token inválido' });
    if (new Date(row.expires_at) < new Date()) return res.status(400).json({ message: 'Token expirado' });
    const hashed = bcrypt.hashSync(newPassword, 10);
    await db.query('UPDATE usuarios SET senha=$1 WHERE id=$2', [hashed, row.user_id]);
    await db.query('DELETE FROM password_resets WHERE token=$1', [tokenReset]);
    return res.json({ message: 'Password redefinida com sucesso' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro em reset-password', error: err.message });
  }
});

// --- USERS ---
app.get('/api/users/me', authMiddleware, async (req, res) => {
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

app.put('/api/users/me', authMiddleware, async (req, res) => {
  try {
    const uid = req.user.id;
    const { nomeCompleto, email, telefone, dataNascimento, genero, nUtente } = req.body;
    const q = 'UPDATE usuarios SET nome_completo=$1, email=$2, telefone=$3, data_nascimento=$4, genero=$5, n_utente=$6 WHERE id=$7 RETURNING id, nome_completo, email, telefone, data_nascimento, genero, n_utente, role';
    const r = await db.query(q, [nomeCompleto, email, telefone, dataNascimento || null, genero || null, nUtente || null, uid]);
    const u = r.rows[0];
    res.json({ user: { id: u.id, nomeCompleto: u.nome_completo, email: u.email, telefone: u.telefone, dataNascimento: u.data_nascimento, genero: u.genero, nUtente: u.n_utente, role: u.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro ao atualizar perfil', error: err.message });
  }
});

// --- PACIENTES (básico) ---
app.get('/api/pacientes', authMiddleware, async (req, res) => {
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

app.get('/api/pacientes/:id', authMiddleware, async (req, res) => {
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

app.post('/api/pacientes', authMiddleware, async (req, res) => {
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

app.put('/api/pacientes/:id', authMiddleware, async (req, res) => {
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

app.delete('/api/pacientes/:id', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    await db.query('DELETE FROM pacientes WHERE id=$1', [id]);
    res.json({ message: 'Paciente eliminado' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro a eliminar paciente', error: err.message });
  }
});

// --- Endpoints de teste para Postgres ---
app.get('/pg/test', async (req, res) => {
  try {
    if (!db.pool) return res.status(400).json({ message: 'Postgres não configurado' });
    const result = await db.query('SELECT NOW() as now');
    res.json({ now: result.rows[0].now });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro ao consultar Postgres', error: err.message });
  }
});

app.get('/pg/usuarios', async (req, res) => {
  try {
    if (!db.pool) return res.status(400).json({ message: 'Postgres não configurado' });
    const result = await db.query('SELECT id, nome_completo, email FROM usuarios LIMIT 100');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Erro ao buscar usuarios no Postgres', error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`API rodando na porta ${PORT}`);
  console.log(`Endpoints: /api/... e /pg/test`);
});
 
