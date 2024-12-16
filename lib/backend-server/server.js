const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const userRoutes = require('./userRoutes');
const itemRoutes = require('./itemRoutes');
const withdrawalRoutes = require('./withdrawalRoutes');
const educationRoutes = require('./educationRoutes');

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use('/users', userRoutes);
app.use('/items', itemRoutes);
app.use('/withdrawals', withdrawalRoutes);
app.use('/education', educationRoutes);

// Add error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});