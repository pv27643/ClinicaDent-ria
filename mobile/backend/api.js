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

// token utilities now provided inside controller_login

const authMiddleware = require('./authMiddleware')(JWT_SECRET);

// --- AUTENTICAÇÃO ---
// mounted router for authentication
const authController = require('./controller_login')({ db, jwt, bcrypt, crypto, JWT_SECRET, ACCESS_TOKEN_EXPIRES, REFRESH_TOKEN_EXPIRES_DAYS });
app.use('/api/auth', authController);

// --- USERS ---
// users controller mounted
const usersController = require('./controller_users')({ db, authMiddleware });
app.use('/api/users', usersController);

// --- PACIENTES (básico) ---
// pacientes controller mounted
const pacientesController = require('./controller_pacientes')({ db, authMiddleware });
app.use('/api/pacientes', pacientesController);

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
 
