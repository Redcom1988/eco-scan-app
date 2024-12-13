const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./userRoutes');
const adminRoutes = require('./adminRoutes');

const app = express();
app.use(bodyParser.json());
app.use('/users', userRoutes);
app.use('/admins', adminRoutes);

app.listen(3000, () => {
  console.log('Server started on port 3000');
});