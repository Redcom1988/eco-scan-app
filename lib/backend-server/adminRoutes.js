const express = require('express');
const db = require('./db');

const router = express.Router();

// Insert a new admin
router.post('/addAdmin', (req, res) => {
    const { role, email, passwordHash, fullName } = req.body;
    let sql = 'INSERT INTO admins (role, email, passwordHash, fullName) VALUES (?, ?, ?, ?)';
    db.query(sql, [role, email, passwordHash, fullName], (err, result) => {
        if (err) {
            console.error('Error inserting admin:', err);
            res.status(500).send('Error inserting admin');
            return;
        }
        res.send('Admin added successfully');
    });
});

// Fetch all admins
router.get('/admins', (req, res) => {
    let sql = 'SELECT * FROM admins';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching admins:', err);
            res.status(500).send('Error fetching admins');
            return;
        }
        res.send(results);
    });
});

// Update a user by id
router.put('/updateAdmins/:id', (req, res) => {
    const { id } = req.params;
    const { role, email, passwordHash, fullName } = req.body;
    let sql = 'UPDATE admins SET role = ?, email = ?, passwordHash = ?, fullName = ? WHERE adminId = ?';
    db.query(sql, [role, email, passwordHash, fullName, id], (err, result) => {
        if (err) {
            console.error('Error updating admin:', err);
            res.status(500).send('Error updating admin');
            return;
        }
        res.send('Admin updated successfully');
    });
});

// Delete a user by id
router.delete('/deleteAdmin/:id', (req, res) => {
    const { id } = req.params;
    let sql = 'DELETE FROM users WHERE adminId = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            console.error('Error deleting admin:', err);
            res.status(500).send('Error deleting admin');
            return;
        }
        res.send('Admin deleted successfully');
    });
});

module.exports = router;