const express = require('express');
const db = require('./db');

const router = express.Router();

router.post('/add', (req, res) => {
    console.log('Received body:', req.body);
    const { contents } = req.body;
    let sql = 'INSERT INTO withdrawals (userId, totalValue, contents) VALUES (?, ?, ?)';

    db.query(sql, [null, 0, JSON.stringify(contents)], (err, result) => {
        if (err) {
            console.error('Error inserting withdrawal:', err);
            res.status(500).send('Error inserting withdrawal');
            return;
        }
        res.send('Withdrawal added successfully');
    });
});

module.exports = router;

// JSON Template
// {
//     "contents": {
//         "items": [
//             {
//                 "id": "someitemId",
//                 "qty": "5"
//             }
//         ]
//     }
// }