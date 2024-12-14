const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');  // You'll need to install this: npm install cors
const userRoutes = require('./userRoutes');
const adminRoutes = require('./adminRoutes');

const app = express();
app.use(cors());  // Add CORS middleware
app.use(bodyParser.json());
app.use('/users', userRoutes);
app.use('/admins', adminRoutes);

// Add error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});