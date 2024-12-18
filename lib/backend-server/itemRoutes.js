const express = require('express');
const db = require('./db');

const router = express.Router();

// Insert a new item
router.post('/addItem', (req, res) => {
    const { itemName, unitValue } = req.body;
    let sql = 'INSERT INTO items (itemName, unitValue) VALUES (?, ?)';
    db.query(sql, [itemName, unitValue], (err, result) => {
        if (err) {
            console.error('Error inserting item:', err);
            res.status(500).send('Error inserting item');
            return;
        }
        res.send('item added successfully');
    });
});

// Fetch all items
router.get('/getItems', (req, res) => {
    let sql = 'SELECT * FROM items';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching items:', err);
            res.status(500).send('Error fetching items');
            return;
        }
        res.send(results);
        console.log(results);
    });
});

// Update an item by id
router.put('/updateItems/:id', (req, res) => {
    const { id } = req.params;
    const { itemName, unitValue } = req.body;
    let sql = 'UPDATE items SET itemValue = ?, unitValue = ? WHERE itemId = ?';
    db.query(sql, [itemName, unitValue, id], (err, result) => {
        if (err) {
            console.error('Error updating item:', err);
            res.status(500).send('Error updating item');
            return;
        }
        res.send('Item updated successfully');
    });
});

// Delete an item by id
router.delete('/deleteItem/:id', (req, res) => {
    const { id } = req.params;
    let sql = 'DELETE FROM items WHERE itemId = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            console.error('Error deleting item:', err);
            res.status(500).send('Error deleting item');
            return;
        }
        res.send('Item deleted successfully');
    });
});

module.exports = router;