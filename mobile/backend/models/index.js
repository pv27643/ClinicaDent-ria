const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize('bd_abd', 'postgres', 'Abcd2425', {
  host: '127.0.0.1',
  dialect: 'postgres',
  port: 5432,
  logging: false,
});

const Appointment = sequelize.define('Appointment', {}, {
  tableName: 'consulta',
  timestamps: false,
});

// Test connection on startup (optional)
sequelize.authenticate()
  .then(() => console.log('Sequelize connected to PostgreSQL'))
  .catch(err => console.error('Sequelize connection error:', err));

module.exports = { sequelize, Appointment, DataTypes };
