const express = require('express');
const db = require('./db');

const router = express.Router();

// Insert a new user
router.post('/addUser', (req, res) => {
    const { username, email, passwordHash, fullName } = req.body;
    let sql = 'INSERT INTO users (username, email, passwordHash, fullName) VALUES (?, ?, ?, ?)';
    db.query(sql, [username, email, passwordHash, fullName], (err, result) => {
        if (err) {
            console.error('Error inserting user:', err);
            res.status(500).send('Error inserting user');
            return;
        }
        res.send('User added successfully');
    });
});

// Fetch all users
router.get('/users', (req, res) => {
    let sql = 'SELECT * FROM users';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching users:', err);
            res.status(500).send('Error fetching users');
            return;
        }
        res.send(results);
    });
});

// Update a user by id
router.put('/updateUser/:id', (req, res) => {
    const { id } = req.params;
    const { username, email, passwordHash, fullName } = req.body;
    let sql = 'UPDATE users SET username = ?, email = ?, passwordHash = ?, fullName = ? WHERE userId = ?';
    db.query(sql, [username, email, passwordHash, fullName, id], (err, result) => {
        if (err) {
            console.error('Error updating user:', err);
            res.status(500).send('Error updating user');
            return;
        }
        res.send('User updated successfully');
    });
});

// Delete a user by id
router.delete('/deleteUser/:id', (req, res) => {
    const { id } = req.params;
    let sql = 'DELETE FROM users WHERE userId = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            console.error('Error deleting user:', err);
            res.status(500).send('Error deleting user');
            return;
        }
        res.send('User deleted successfully');
    });
});

module.exports = router;