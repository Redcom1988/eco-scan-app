const express = require('express');
const db = require('./db');

const router = express.Router();

// Insert a new user
router.post('/addUser', (req, res) => {
    const { username, email, passwordHash, fullName, role } = req.body;
    let sql = 'INSERT INTO users (username, email, passwordHash, fullName, role) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [username, email, passwordHash, fullName, role], (err, result) => {
        if (err) {
            console.error('Error inserting user:', err);
            res.status(500).send('Error inserting user');
            return;
        }
        res.send('User added successfully');
    });
});

// Get userdata from username
router.get('/getUser/:username', (req, res) => {
    const { username } = req.params;
    let sql = 'SELECT * FROM users WHERE username = ?';
    db.query(sql, [username], (err, results) => {
        if (err) {
            console.error('Error fetching user:', err);
            res.status(500).send('Error fetching user');
            return;
        }
        res.send(results);
    });
});

// Fetch all users
router.get('/', (req, res) => {
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
    const { username, email, passwordHash, fullName, role } = req.body;
    let sql = 'UPDATE users SET username = ?, email = ?, passwordHash = ?, fullName = ?, role = ? WHERE userId = ?';
    db.query(sql, [username, email, passwordHash, fullName, role, id], (err, result) => {
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

// Login
router.post('/login', async (req, res) => {
    try {
        const { email, passwordHash } = req.body;
        console.log('Login attempt:', { email, passwordHash });
        const sql = 'SELECT * FROM users WHERE email = ? AND passwordHash = ?';

        db.query(sql, [email, passwordHash], (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return res.status(500).json({
                    success: false,
                    error: 'Internal server error'
                });
            }
            console.log('Query results:', results);

            if (results.length > 0) {
                const user = results[0];
                res.status(200).json({
                    success: true,
                    username: user.username,
                    fullName: user.full_name,
                    email: user.email
                });
            } else {
                res.status(401).json({
                    success: false,
                    error: 'Invalid email or password'
                });
            }
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({
            success: false,
            error: 'Server error'
        });
    }
});

router.get('/getBalance', async (req, res) => {
    try {
        const { username } = req.query;
        console.log('Balance request:', { username });
        const sql = 'SELECT currentBalance FROM users WHERE username = ?';

        db.query(sql, [username], (err, results) => {
            if (err) {
                console.error('Database error:', err);
                return res.status(500).json({
                    success: false,
                    error: 'Internal server error'
                });
            }
            console.log('Query results:', results);

            if (results.length > 0) {
                const user = results[0];
                res.status(200).json({
                    success: true,
                    balance: user.currentBalance
                });
            } else {
                res.status(404).json({
                    success: false,
                    error: 'User not found'
                });
            }
        });
    } catch (error) {
        console.error('Balance error:', error);
        res.status(500).json({
            success: false,
            error: 'Server error'
        });
    }
});

module.exports = router;