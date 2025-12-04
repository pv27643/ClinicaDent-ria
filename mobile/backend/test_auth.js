// test_auth.js - registra um utilizador de teste e tenta efectuar login
(async () => {
  try {
    const registerRes = await fetch('http://localhost:3001/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ nomeCompleto: 'Teste', email: 'test@example.com', password: 'secret123', confirmPassword: 'secret123', aceitouTermos: true })
    });
    const registerJson = await registerRes.json().catch(() => ({}));
    console.log('REGISTER', registerRes.status, registerJson);

    const loginRes = await fetch('http://localhost:3001/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', password: 'secret123' })
    });
    const loginJson = await loginRes.json().catch(() => ({}));
    console.log('LOGIN', loginRes.status, loginJson);
  } catch (err) {
    console.error('ERROR', err && err.message ? err.message : err);
    process.exitCode = 2;
  }
})();
