const mysql = require('mysql');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ecoscan'
});

db.connect(err => {
    if (err) throw err;
    console.log('MySQL connected...');

    const createUserTable = `
    CREATE TABLE users (
      userId INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,
      passwordHash VARCHAR(255) NOT NULL,
      fullName VARCHAR(255)
    )
  `;

    const createAdminTable = `
    CREATE TABLE admins (
        adminId INT AUTO_INCREMENT PRIMARY KEY,
        role VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        passwordHash VARCHAR(255) NOT NULL,
        fullName VARCHAR(255)
        )
    `

    db.query(createUserTable, (err, result) => {
        if (err) throw err;
        console.log('Users table created');
        db.end();
    });

    db.query(createAdminTable, (err, result) => {
        if (err) throw err;
        console.log('Admin table created');
        db.end();
    });
});