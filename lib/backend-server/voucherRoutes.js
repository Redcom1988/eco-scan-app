const express = require('express');
const db = require('./db');

const router = express.Router();

// Fetch all vouchers
router.get('/getVouchers', (req, res) => {
    let sql = 'SELECT * FROM vouchers ORDER BY expiryDate DESC';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching vouchers:', err);
            res.status(500).send('Error fetching vouchers');
            return;
        }
        res.send(results);
        console.log(results);
    });
});

// Edit voucher from id
router.post('/editVoucher', (req, res) => {
    const { voucherId, voucherCode, voucherValue, expiryDate, isActive } = req.body;
    let sql = 'UPDATE vouchers SET voucherCode = ?, voucherValue = ?, expiryDate = ?, isActive = ? WHERE voucherId = ?';
    db.query(sql, [voucherCode, voucherValue, expiryDate, isActive, voucherId], (err, result) => {
        if (err) {
            console.error('Error updating voucher:', err);
            res.status(500).send('Error updating voucher');
            return;
        }
        res.send('Voucher updated successfully');
    });
});

// Add voucher
router.post('/addVoucher', (req, res) => {
    const { voucherCode, voucherValue, expiryDate, isActive } = req.body;
    let sql = 'INSERT INTO vouchers (voucherCode, voucherValue, expiryDate, isActive) VALUES (?, ?, ?, ?)';
    db.query(sql, [voucherCode, voucherValue, expiryDate, isActive], (err, result) => {
        if (err) {
            console.error('Error inserting voucher:', err);
            res.status(500).send('Error inserting voucher');
            return;
        }
        res.send('Voucher added successfully');
    });
});

// Fetch all active vouchers
router.get('/getActiveVouchers', (req, res) => {
    let sql = 'SELECT * FROM vouchers WHERE isActive = 1 ORDER BY expiryDate DESC';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching vouchers:', err);
            res.status(500).send('Error fetching vouchers');
            return;
        }
        res.send(results);
        console.log(results);
    });
});

router.post('/claimVoucher', (req, res) => {
    const { userId, voucherId } = req.body;
    const currentDateTime = new Date().toISOString();

    const checkQuery = `
        SELECT 
            (SELECT currentBalance FROM users WHERE userId = ?) as currentBalance,
            (SELECT voucherValue FROM vouchers WHERE voucherId = ? AND expiryDate > NOW() AND isActive = 1) as voucherValue
    `;

    db.query(checkQuery, [userId, voucherId], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        const { currentBalance, voucherValue } = results[0];

        if (!voucherValue) {
            return res.status(400).json({ error: 'Invalid or expired voucher' });
        }
        if (currentBalance < voucherValue) {
            console.log('Insufficient balance:', currentBalance, voucherValue);
            return res.status(400).json({ error: 'Insufficient balance' });
        }

        db.beginTransaction(err => {
            if (err) {
                return res.status(500).json({ error: 'Transaction error' });
            }
            const updateBalanceQuery = 'UPDATE users SET currentBalance = currentBalance - ? WHERE userId = ?';

            // 3. Log the transaction
            const insertLogQuery = `
                INSERT INTO redeemRecord 
                (userId, voucherId, redeemDate)
                VALUES (?, ?, ?)
            `;

            // Execute all queries in transaction
            db.query(updateBalanceQuery, [voucherValue, userId], (err) => {
                if (err) {
                    return db.rollback(() => {
                        res.status(500).json({ error: 'Balance update failed' });
                    });
                }
                db.query(insertLogQuery, [userId, voucherId, currentDateTime], (err) => {
                    if (err) {
                        return db.rollback(() => {
                            res.status(500).json({ error: 'Transaction logging failed' });
                        });
                    }

                    db.commit(err => {
                        if (err) {
                            return db.rollback(() => {
                                res.status(500).json({ error: 'Transaction commit failed' });
                            });
                        }

                        res.json({
                            success: true,
                            message: 'Voucher claimed successfully',
                            data: {
                                newBalance: currentBalance - voucherValue,
                                claimedAt: currentDateTime,
                            }
                        });
                    });
                });
            });
        });
    });
});

router.get('/getOwnedVouchers/:userId', (req, res) => {
    const { userId } = req.params;
    const sql = `
        SELECT 
            v.*,
            r.redeemId,
            r.redeemDate,
            r.used
        FROM redeemRecord r
        JOIN vouchers v ON r.voucherId = v.voucherId
        WHERE r.userId = ?
        ORDER BY r.redeemDate DESC
    `;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }
        res.send(results);
        console.log(results);
    });
});

router.get('/getRedeemRecords/:userId', (req, res) => {
    const { userId } = req.params;

    const sql = `
        SELECT 
            r.redeemDate,
            v.voucherValue,
            v.voucherCode
        FROM redeemrecord r
        JOIN vouchers v ON r.voucherId = v.voucherId
        WHERE r.userId = ?
        ORDER BY r.redeemDate DESC`;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching redeem records:', err);
            return res.status(500).json({
                success: false,
                error: 'Error fetching redeem records'
            });
        }

        const formattedResults = results.map(record => ({
            redeemDate: record.redeemDate.toISOString(),
            voucherValue: parseFloat(record.voucherValue),
            voucherCode: record.voucherCode
        }));

        res.json(formattedResults);
    });
});

module.exports = router;