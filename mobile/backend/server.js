const express = require('express');
const app = express();
const port = 4000;

app.set('port', port);

app.use(express.json());

const appointmentsRoutes = require('./routes/appointementRoutes');

app.use('/appointments', appointmentsRoutes);




app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
