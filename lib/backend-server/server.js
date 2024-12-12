const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'your_password',
  database: 'your_database'
});

db.connect(err => {
  if (err) throw err;
  console.log('MySQL connected...');
});

app.get('/users', (req, res) => {
  let sql = 'SELECT * FROM users';
  db.query(sql, (err, results) => {
    if (err) throw err;
    res.send(results);
  });
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});