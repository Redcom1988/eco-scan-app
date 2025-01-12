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
    CREATE TABLE IF NOT EXISTS users (
      userId INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,
      passwordHash VARCHAR(255) NOT NULL,
      fullName VARCHAR(255),
      currentBalance FLOAT DEFAULT 0,
      role ENUM('user', 'admin') DEFAULT 'user'
    )
  `;

    const createItemsTable = `
    CREATE TABLE IF NOT EXISTS items (
        itemId INT AUTO_INCREMENT PRIMARY KEY,
        itemName VARCHAR(255) NOT NULL,
        unitValue DECIMAL(10,2) NOT NULL
    )
    `;

    const createWithdrawalsTable = `
    CREATE TABLE IF NOT EXISTS withdrawals (
        withdrawalId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT DEFAULT NULL,
        totalValue DECIMAL(10,2) DEFAULT 0,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        contents json
    )
    `;

    const createSupportTicketsTable = `
    CREATE TABLE IF NOT EXISTS support_tickets (
        ticketId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT,
        subject VARCHAR(255),
        description TEXT,
        status VARCHAR(255),
        FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE
    )
    `;

    const createCommentTable = `
    CREATE TABLE IF NOT EXISTS comments (
        commentId INT AUTO_INCREMENT PRIMARY KEY,
        ticketId INT,
        parentCommentId INT NULL,
        userId INT NULL,
        text TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (ticketId) REFERENCES support_tickets(ticketId) ON DELETE CASCADE,
        FOREIGN KEY (parentCommentId) REFERENCES comments(commentId) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL
    )
    `;

    const createEducationContentTable = `
    CREATE TABLE IF NOT EXISTS educationContent (
        contentId INT AUTO_INCREMENT PRIMARY KEY,
        contentTitle VARCHAR(255),
        contentDescription TEXT,
        contentFull TEXT,
        contentImage VARCHAR(255),
        contentViews INT DEFAULT 0,
        contentLikes INT DEFAULT 0,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    `;

    const createRedeemRecordTable = `
    CREATE TABLE IF NOT EXISTS redeemRecord (
        redeemId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT,
        voucherId INT,
        used BOOLEAN DEFAULT FALSE,
        redeemDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES users(userId),
        FOREIGN KEY (voucherId) REFERENCES vouchers(voucherId)
    )
    `;

    const createVouchersTable = `
    CREATE TABLE IF NOT EXISTS vouchers (
        voucherId INT AUTO_INCREMENT PRIMARY KEY,
        voucherCode VARCHAR(255) UNIQUE,
        voucherPrice DECIMAL(10,2),
        voucherDesc TEXT,
        expiryDate DATE,
        isActive BOOLEAN DEFAULT TRUE
    )
    `;

    const tables = [
        createUserTable,
        createItemsTable,
        createWithdrawalsTable,
        createSupportTicketsTable,
        createCommentTable,
        createEducationContentTable,
        createRedeemRecordTable,
        createVouchersTable,
    ];

    tables.forEach(query => {
        db.query(query, (err, result) => {
            if (err) {
                console.error('Error creating table:', err);
            } else {
                console.log('Table created or already exists');
            }
        });
    });

    db.end();
});