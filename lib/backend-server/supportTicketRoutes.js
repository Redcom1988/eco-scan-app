// supportTickets.js
const express = require('express');
const db = require('./db');

const router = express.Router();

// Create a new support ticket
router.post('/createTicket', (req, res) => {
    const { userId, subject, description, status } = req.body;
    const sql = 'INSERT INTO support_tickets (userId, subject, description, status) VALUES (?, ?, ?, ?)';

    db.query(sql, [userId, subject, description, status], (err, result) => {
        if (err) {
            console.error('Error creating support ticket:', err);
            res.status(500).json({
                success: false,
                error: 'Error creating support ticket'
            });
            return;
        }
        res.status(200).json({
            success: true,
            ticketId: result.insertId,
            message: 'Support ticket created successfully'
        });
    });
});

// Get all support tickets
router.get('/getAllTickets', (req, res) => {
    const sql = `
        SELECT t.*, COUNT(c.commentId) as comment_count 
        FROM support_tickets t 
        LEFT JOIN comments c ON t.ticketId = c.ticketId 
        GROUP BY t.ticketId 
        ORDER BY t.ticketId DESC
    `;

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching tickets:', err);
            res.status(500).json({
                success: false,
                error: 'Error fetching tickets'
            });
            return;
        }
        res.status(200).json({
            success: true,
            tickets: results
        });
    });
});

// Get a specific ticket with its comments
router.get('/getTicket/:ticketId', (req, res) => {
    const { ticketId } = req.params;
    const ticketSql = 'SELECT * FROM support_tickets WHERE ticketId = ?';
    const commentsSql = `
        SELECT c.*, u.username 
        FROM comments c 
        LEFT JOIN users u ON c.userId = u.userId 
        WHERE c.ticketId = ? 
        ORDER BY c.created_at ASC
    `;

    db.query(ticketSql, [ticketId], (err, ticketResults) => {
        if (err) {
            console.error('Error fetching ticket:', err);
            res.status(500).json({
                success: false,
                error: 'Error fetching ticket'
            });
            return;
        }

        if (ticketResults.length === 0) {
            res.status(404).json({
                success: false,
                error: 'Ticket not found'
            });
            return;
        }

        db.query(commentsSql, [ticketId], (err, commentResults) => {
            if (err) {
                console.error('Error fetching comments:', err);
                res.status(500).json({
                    success: false,
                    error: 'Error fetching comments'
                });
                return;
            }

            res.status(200).json({
                success: true,
                ticket: {
                    ...ticketResults[0],
                    comments: commentResults
                }
            });
        });
    });
});

// Update a support ticket
router.put('/updateTicket/:ticketId', (req, res) => {
    const { ticketId } = req.params;
    const { subject, description, status } = req.body;
    const sql = 'UPDATE support_tickets SET subject = ?, description = ?, status = ? WHERE ticketId = ?';

    db.query(sql, [subject, description, status, ticketId], (err, result) => {
        if (err) {
            console.error('Error updating ticket:', err);
            res.status(500).json({
                success: false,
                error: 'Error updating ticket'
            });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Ticket updated successfully'
        });
    });
});

// Add a comment to a ticket
router.post('/addComment', (req, res) => {
    const { ticketId, userId, text, parentCommentId } = req.body;
    const sql = 'INSERT INTO comments (ticketId, userId, text, parentCommentId) VALUES (?, ?, ?, ?)';

    db.query(sql, [ticketId, userId, text, parentCommentId], (err, result) => {
        if (err) {
            console.error('Error adding comment:', err);
            res.status(500).json({
                success: false,
                error: 'Error adding comment'
            });
            return;
        }
        res.status(200).json({
            success: true,
            commentId: result.insertId,
            message: 'Comment added successfully'
        });
    });
});

// Get comments for a specific ticket
router.get('/getComments/:ticketId', (req, res) => {
    const { ticketId } = req.params;
    const sql = `
        SELECT c.*, u.username 
        FROM comments c 
        LEFT JOIN users u ON c.userId = u.userId 
        WHERE c.ticketId = ? 
        ORDER BY c.created_at ASC
    `;

    db.query(sql, [ticketId], (err, results) => {
        if (err) {
            console.error('Error fetching comments:', err);
            res.status(500).json({
                success: false,
                error: 'Error fetching comments'
            });
            return;
        }
        res.status(200).json({
            success: true,
            comments: results
        });
    });
});

// Get tickets by user ID
router.get('/getUserTickets/:userId', (req, res) => {
    const { userId } = req.params;
    const sql = `
        SELECT t.*, COUNT(c.commentId) as comment_count 
        FROM support_tickets t 
        LEFT JOIN comments c ON t.ticketId = c.ticketId 
        WHERE t.userId = ? 
        GROUP BY t.ticketId 
        ORDER BY t.ticketId DESC
    `;

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching user tickets:', err);
            res.status(500).json({
                success: false,
                error: 'Error fetching user tickets'
            });
            return;
        }
        res.status(200).json({
            success: true,
            tickets: results
        });
    });
});

// Delete a comment
router.delete('/deleteComment/:commentId', (req, res) => {
    const { commentId } = req.params;
    const sql = 'DELETE FROM comments WHERE commentId = ?';

    db.query(sql, [commentId], (err, result) => {
        if (err) {
            console.error('Error deleting comment:', err);
            res.status(500).json({
                success: false,
                error: 'Error deleting comment'
            });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Comment deleted successfully'
        });
    });
});

module.exports = router;