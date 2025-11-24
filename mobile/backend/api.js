// Dependências principais
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const jwt = require('jsonwebtoken');

// Configurações 
const DB_PATH = path.join(__dirname, 'db.json'); 
const PORT = process.env.PORT || 3001; 
const JWT_SECRET = process.env.JWT_SECRET || 'change_this_secret'; 

function readDB() {
  try {
    //retorna objeto vazio em erro
    return JSON.parse(fs.readFileSync(DB_PATH, 'utf8') || '{}');
  } catch (e) {
    return {};
  }
}

function writeDB(data) {
  fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
}

// Inicializa o app Express com parsers e CORS
const app = express();
app.use(cors());
app.use(express.json());




//AUTENTICAÇÃO
// Verifica credenciais e retorna um JWT se válidas
app.post('/auth/login', (req, res) => {
  const { email, senha } = req.body;
  if (!email || !senha) return res.status(400).json({ message: 'email e senha são obrigatórios' });
  const db = readDB();
  const user = (db.usuarios || []).find(u => u.email === email);

  // Em protótipo, compara senha em texto; em produção use hashing (bcrypt)
  if (!user || user.senha !== senha) return res.status(401).json({ message: 'Credenciais inválidas' });
  const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '8h' });
  const safeUser = { id: user.id, nome: user.nome, email: user.email };
  res.json({ token, user: safeUser });
});


// Cria um usuário novo 
app.post('/auth/register', (req, res) => {
  const { nome, email, senha } = req.body;
  if (!nome || !email || !senha) return res.status(400).json({ message: 'nome, email e senha são obrigatórios' });
  const db = readDB();
  db.usuarios = db.usuarios || [];
  if (db.usuarios.find(u => u.email === email)) return res.status(409).json({ message: 'Email já cadastrado' });
  const id = db.usuarios.reduce((m, u) => Math.max(m, u.id || 0), 0) + 1;
  const newUser = { id, nome, email, senha };
  db.usuarios.push(newUser);
  writeDB(db);
  const token = jwt.sign({ id, email }, JWT_SECRET, { expiresIn: '8h' });
  res.status(201).json({ token, user: { id, nome, email } });
});


// Retorna informações do usuário a partir do token JWT no header Authorization
app.get('/auth/me', (req, res) => {
  const auth = req.headers.authorization;
  if (!auth) return res.status(401).json({ message: 'Token não fornecido' });
  const parts = auth.split(' ');
  if (parts.length !== 2) return res.status(401).json({ message: 'Header Authorization inválido' });
  const token = parts[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    const db = readDB();
    const user = (db.usuarios || []).find(u => u.id === payload.id);
    if (!user) return res.status(404).json({ message: 'Usuário não encontrado' });
    res.json({ id: user.id, nome: user.nome, email: user.email });
  } catch (err) {
    return res.status(401).json({ message: 'Token inválido' });
  }
});

// Start do servidor
app.listen(PORT, () => {
  console.log(`Auth API rodando na porta ${PORT}`);
  console.log(`Endpoints: POST /auth/login  POST /auth/register  GET /auth/me`);
});
