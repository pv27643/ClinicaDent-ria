// db.js — Conexão com PostgreSQL usando variáveis de ambiente
const { Pool } = require('pg');
require('dotenv').config();

const {
  DATABASE_URL,
  DB_HOST,
  DB_PORT,
  DB_NAME,
  DB_USER,
  DB_PASSWORD,
} = process.env;

let pool;
if (process.env.FORCE_DB_MOCK === '1') {
  console.log('FORCE_DB_MOCK=1 -> usando mock DB (em memória)');
  // In-memory mock storage — supports basic auth/register flows
  const mock = {
    users: [
      { id: 1, nome_completo: 'Teste Um', email: 'teste1@example.com', senha: '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', telefone: null, role: 'Paciente' },
      { id: 2, nome_completo: 'Teste Dois', email: 'teste2@example.com', senha: '$2a$10$YYYYYYYYYYYYYYYYYYYYYYYYYYYYYY', telefone: null, role: 'Paciente' }
    ],
    refreshTokens: [],
    passwordResets: [],
    nextId: { users: 3 }
  };

  pool = {
    query: async (text, params) => {
      const t = (text || '').trim();

      // SELECT NOW()
      if (/SELECT\s+NOW\(\)\s+as\s+now/i.test(t)) {
        return { rows: [{ now: new Date().toISOString() }] };
      }

      // SELECT users list
      if (/SELECT\s+id,\s*nome_completo,\s*email\s+FROM\s+usuarios/i.test(t)) {
        return { rows: mock.users.map(u => ({ id: u.id, nome_completo: u.nome_completo, email: u.email })) };
      }

      // SELECT usuario by email (exists check)
      if (/SELECT\s+id\s+FROM\s+usuarios\s+WHERE\s+email=\$1/i.test(t)) {
        const email = params && params[0];
        const u = mock.users.find(x => x.email === email);
        return { rows: u ? [{ id: u.id }] : [] };
      }

      // SELECT full usuario by email (login)
      if (/SELECT\s+id,\s*nome_completo,\s*telefone,\s*email,\s*senha,\s*role\s+FROM\s+usuarios\s+WHERE\s+email=\$1/i.test(t)) {
        const email = params && params[0];
        const u = mock.users.find(x => x.email === email);
        return { rows: u ? [u] : [] };
      }

      // SELECT usuario by id (users/me)
      if (/SELECT\s+id,\s*nome_completo,\s*email,\s*telefone,\s*data_nascimento,\s*genero,\s*n_utente,\s*role\s+FROM\s+usuarios\s+WHERE\s+id=\$1/i.test(t)) {
        const id = params && params[0];
        const u = mock.users.find(x => x.id === id);
        return { rows: u ? [u] : [] };
      }

      // INSERT INTO usuarios ... RETURNING id, nome_completo, email
      if (/INSERT\s+INTO\s+usuarios\s*\(/i.test(t) && /RETURNING\s+id,\s*nome_completo,\s*email/i.test(t)) {
        const [nome_completo, telefone, email, senha, role] = params;
        const id = mock.nextId.users++;
        const u = { id, nome_completo, telefone, email, senha, role };
        mock.users.push(u);
        return { rows: [{ id: u.id, nome_completo: u.nome_completo, email: u.email }] };
      }

      // INSERT refresh token
      if (/INSERT\s+INTO\s+refresh_tokens/i.test(t)) {
        const [token, userId, expiresAt] = params;
        mock.refreshTokens.push({ token, userId, expiresAt });
        return { rows: [] };
      }

      // SELECT refresh token
      if (/SELECT\s+token,\s*user_id,\s*expires_at\s+FROM\s+refresh_tokens\s+WHERE\s+token=\$1/i.test(t)) {
        const token = params && params[0];
        const r = mock.refreshTokens.find(x => x.token === token);
        return { rows: r ? [r] : [] };
      }

      // DELETE refresh token
      if (/DELETE\s+FROM\s+refresh_tokens\s+WHERE\s+token=\$1/i.test(t)) {
        const token = params && params[0];
        mock.refreshTokens = mock.refreshTokens.filter(x => x.token !== token);
        return { rows: [] };
      }

      // password_resets insert
      if (/INSERT\s+INTO\s+password_resets/i.test(t)) {
        const [userId, token, expiresAt] = params;
        mock.passwordResets.push({ userId, token, expiresAt });
        return { rows: [] };
      }

      // select password_resets by token
      if (/SELECT\s+user_id,\s*expires_at\s+FROM\s+password_resets\s+WHERE\s+token=\$1/i.test(t)) {
        const token = params && params[0];
        const r = mock.passwordResets.find(x => x.token === token);
        return { rows: r ? [{ user_id: r.userId, expires_at: r.expiresAt }] : [] };
      }

      // DELETE password_resets
      if (/DELETE\s+FROM\s+password_resets\s+WHERE\s+token=\$1/i.test(t)) {
        const token = params && params[0];
        mock.passwordResets = mock.passwordResets.filter(x => x.token !== token);
        return { rows: [] };
      }

      // UPDATE usuarios SET senha
      if (/UPDATE\s+usuarios\s+SET\s+senha=\$1\s+WHERE\s+id=\$2/i.test(t)) {
        const [senha, id] = params;
        const u = mock.users.find(x => x.id === id);
        if (u) u.senha = senha;
        return { rows: [] };
      }

      // UPDATE usuarios ... RETURNING id
      if (/UPDATE\s+usuarios\s+SET[\s\S]*RETURNING\s+id/i.test(t)) {
        const id = params && params[params.length - 1];
        const u = mock.users.find(x => x.id === id);
        if (u) return { rows: [{ id: u.id }] };
        return { rows: [] };
      }

      // Default
      return { rows: [] };
    }
  };
} else if (DATABASE_URL || DB_HOST) {
  const config = DATABASE_URL
    ? { connectionString: DATABASE_URL }
    : {
        host: DB_HOST || 'localhost',
        port: DB_PORT ? parseInt(DB_PORT, 10) : 5432,
        database: DB_NAME,
        user: DB_USER,
        password: DB_PASSWORD,
      };

  pool = new Pool(config);
  pool.on('error', (err) => {
    console.error('Postgres pool error', err);
  });
} else {
  console.log('Postgres não configurado (nenhuma variável DB encontrada).');
}

async function query(text, params) {
  if (!pool) throw new Error('Pool PostgreSQL não inicializado. Verifique as variáveis de ambiente.');
  const res = await pool.query(text, params);
  return res;
}

module.exports = {
  query,
  pool,
};
