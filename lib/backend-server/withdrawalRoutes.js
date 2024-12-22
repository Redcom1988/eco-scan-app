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

router.put('/claim/:withdrawalId', (req, res) => {
    const { withdrawalId } = req.params;
    const { userId } = req.body;  // Assuming userId is sent in request body

    // First get the withdrawal record
    db.query('SELECT totalValue FROM withdrawals WHERE withdrawalId = ?', [withdrawalId], (err, withdrawalResult) => {
        if (err) {
            console.error('Error fetching withdrawal:', err);
            return res.status(500).send('Error fetching withdrawal details');
        }

        if (!withdrawalResult || withdrawalResult.length === 0) {
            return res.status(404).send('Withdrawal record not found');
        }

        const totalValue = withdrawalResult[0].totalValue;

        // Start a transaction to ensure both updates succeed or fail together
        db.beginTransaction((err) => {
            if (err) {
                console.error('Error starting transaction:', err);
                return res.status(500).send('Error processing request');
            }

            // Update the withdrawal record with the userId
            db.query('UPDATE withdrawals SET userId = ? WHERE withdrawalId = ?',
                [userId, withdrawalId],
                (err, updateResult) => {
                    if (err) {
                        return db.rollback(() => {
                            console.error('Error updating withdrawal:', err);
                            res.status(500).send('Error updating withdrawal');
                        });
                    }

                    // Update user's currentBalance
                    db.query('UPDATE users SET currentBalance = currentBalance + ? WHERE userId = ?',
                        [totalValue, userId],
                        (err, balanceResult) => {
                            if (err) {
                                return db.rollback(() => {
                                    console.error('Error updating balance:', err);
                                    res.status(500).send('Error updating balance');
                                });
                            }

                            // Commit the transaction
                            db.commit((err) => {
                                if (err) {
                                    return db.rollback(() => {
                                        console.error('Error committing transaction:', err);
                                        res.status(500).send('Error completing transaction');
                                    });
                                }
                                res.send({
                                    message: 'Claim processed successfully',
                                    updatedValue: totalValue
                                });
                            });
                        }
                    );
                }
            );
        });
    });
});

router.get('/:withdrawalId', (req, res) => {
    const { withdrawalId } = req.params;

    const sql = `
        SELECT w.*, u.username as claimedBy 
        FROM withdrawals w 
        LEFT JOIN users u ON w.userId = u.userId 
        WHERE w.withdrawalId = ?`;

    db.query(sql, [withdrawalId], (err, results) => {
        if (err) {
            console.error('Error fetching withdrawal:', err);
            return res.status(500).json({
                success: false,
                error: 'Error fetching withdrawal details'
            });
        }

        if (results.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Withdrawal not found'
            });
        }

        res.json({
            success: true,
            data: results[0]
        });
    });
});

router.get('/records/:userId', (req, res) => {
    const { userId } = req.params;

    const sql = `SELECT totalValue, timestamp, contents FROM withdrawals WHERE userId = ?`;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching withdrawals:', err);
            return res.status(500).json({
                success: false,
                error: 'Error fetching withdrawal details'
            });
        }

        res.json({
            success: true,
            data: results
        });
    });
});

module.exports = router;