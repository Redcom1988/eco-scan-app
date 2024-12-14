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
      fullName VARCHAR(255)
      currentBalance FLOAT DEFAULT 0,
    )
  `;

    const createAdminTable = `
    CREATE TABLE IF NOT EXISTS admins (
        adminId INT AUTO_INCREMENT PRIMARY KEY,
        role VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        passwordHash VARCHAR(255) NOT NULL,
        fullName VARCHAR(255)
    )
    `;

    const createItemsTable = `
    CREATE TABLE IF NOT EXISTS items (
        itemId INT AUTO_INCREMENT PRIMARY KEY,
        itemName VARCHAR(255) NOT NULL,
        unitValue DECIMAL(10,2) NOT NULL
    )
    `;

    const createWidthdrawalsTable = `
    CREATE TABLE IF NOT EXISTS widthdrawals (
        withdrawalId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT DEFAULT NULL,
        totalValue DECIMAL(10,2) DEFAULT 0,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        contents json
    )
    `;

    const createSupportTicketTable = `
    CREATE TABLE IF NOT EXISTS supportTicket (
        ticketId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT,
        subject VARCHAR(255),
        ticketDescription TEXT,
        ticketStatus VARCHAR(255),
        FOREIGN KEY (userId) REFERENCES users(userId)
    )
    `;

    const createCommentTable = `
    CREATE TABLE IF NOT EXISTS comments (
        commentId INT AUTO_INCREMENT PRIMARY KEY,
        ticketId INT,
        parentCommentId INT NULL,
        userId INT NULL,
        adminId INT NULL,
        commentText TEXT,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (ticketId) REFERENCES supportTicket(ticketId),
        FOREIGN KEY (parentCommentId) REFERENCES comments(commentId),
        FOREIGN KEY (userId) REFERENCES users(userId),
        FOREIGN KEY (adminId) REFERENCES admins(adminId)
    )
    `;

    const createEducationContentTable = `
    CREATE TABLE IF NOT EXISTS educationContent (
        contentId INT AUTO_INCREMENT PRIMARY KEY,
        contentTitle VARCHAR(255),
        contentDescription TEXT,
        contentFull TEXT,
        contentImage VARCHAR(255),
        contentLikes INT DEFAULT 0,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    `;

    const createRedeemRecordTable = `
    CREATE TABLE IF NOT EXISTS redeemRecord (
        redeemId INT AUTO_INCREMENT PRIMARY KEY,
        userId INT,
        voucherId INT,
        redeemDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (userId) REFERENCES users(userId),
        FOREIGN KEY (voucherId) REFERENCES vouchers(voucherId)
    )
    `;

    const createVouchersTable = `
    CREATE TABLE IF NOT EXISTS vouchers (
        voucherId INT AUTO_INCREMENT PRIMARY KEY,
        voucherCode VARCHAR(255) UNIQUE,
        voucherValue DECIMAL(10,2),
        expiryDate DATE,
        isActive BOOLEAN DEFAULT TRUE
    )
    `;

    const createOwnedVouchersTable = `
    CREATE TABLE IF NOT EXISTS ownedVouchers (
        userId INT,
        voucherId INT,
        FOREIGN KEY (userId) REFERENCES users(userId),
        FOREIGN KEY (voucherId) REFERENCES vouchers(voucherId)
    )
    `;

    const tables = [
        createUserTable,
        createAdminTable,
        createItemsTable,
        createWidthdrawalsTable,
        createSupportTicketTable,
        createCommentTable,
        createEducationContentTable,
        createRedeemRecordTable,
        createVouchersTable,
        createOwnedVouchersTable
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