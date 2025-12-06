const { Pool } = require("pg");

const pool = new Pool({
  user: "postgres",
  host: "127.0.0.1",
  database: "bd_abd",
  password: "Abcd2425",
  port: 5432,
});

(async () => {
  const client = await pool.connect(); 
  try {
    const res = await client.query("SELECT NOW()");
    console.log(res.rows);
  } catch (err) {
    console.error(err);
  } finally {
    client.release(); 
    await pool.end();
  }
})();
