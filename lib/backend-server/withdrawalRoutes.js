const express = require('express');
const db = require('./db');

const router = express.Router();

async function calculateTotalValue(items) {
    return new Promise((resolve, reject) => {
        const itemIds = items.map(item => item.id);
        const sql = 'SELECT itemId, unitValue FROM items WHERE itemId IN (?)';

        db.query(sql, [itemIds], (err, results) => {
            if (err) {
                reject(err);
                return;
            }

            const unitValues = new Map(
                results.map(item => [item.itemId.toString(), item.unitValue])
            );

            const total = items.reduce((sum, item) => {
                const unitValue = unitValues.get(item.id) || 0;
                return sum + (unitValue * parseInt(item.qty));
            }, 0);

            resolve(total);
        });
    });
}

router.post('/add', async (req, res) => {
    console.log('Received body:', req.body);
    const { contents } = req.body;

    try {
        const totalValue = await calculateTotalValue(contents.items);

        let sql = 'INSERT INTO withdrawals (userId, totalValue, contents) VALUES (?, ?, ?)';

        db.query(sql, [null, totalValue, JSON.stringify(contents)], (err, result) => {
            if (err) {
                console.error('Error inserting withdrawal:', err);
                res.status(500).json({
                    success: false,
                    error: 'Error inserting withdrawal'
                });
                return;
            }

            res.json({
                success: true,
                withdrawalId: result.insertId,
                totalValue: totalValue
            });
        });
    } catch (err) {
        console.error('Error calculating total value:', err);
        res.status(500).json({
            success: false,
            error: 'Error calculating total value'
        });
    }
});

module.exports = router;