const express = require('express');
const db = require('./db');
const router = express.Router();

// Get all education content
router.get('/', (req, res) => {
    let sql = 'SELECT * FROM educationcontent';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching education:', err);
            res.status(500).send('Error fetching education');
            return;
        }
        res.json(results);
    });
});

router.get('/popular', (req, res) => {
    let sql = 'SELECT * FROM educationcontent ORDER BY contentViews DESC LIMIT 5';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching popular education:', err);
            res.status(500).send('Error fetching popular education');
            return;
        }
        res.json(results);
    });
});

// Get single education content by ID
router.get('/:id', (req, res) => {
    const contentId = req.params.id;
    let sql = 'SELECT * FROM educationcontent WHERE contentId = ?';

    db.query(sql, [contentId], (err, results) => {
        if (err) {
            console.error('Error fetching education content:', err);
            res.status(500).send('Error fetching education content');
            return;
        }
        if (results.length === 0) {
            res.status(404).send('Content not found');
            return;
        }
        res.json(results[0]);
    });
});

// Increment views for a specific content
router.put('/:id/views', (req, res) => {
    const contentId = req.params.id;
    let sql = 'UPDATE educationcontent SET contentViews = contentViews + 1 WHERE contentId = ?';

    db.query(sql, [contentId], (err, result) => {
        if (err) {
            console.error('Error updating views:', err);
            res.status(500).send('Error updating views');
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).send('Content not found');
            return;
        }
        res.json({ success: true, message: 'Views updated successfully' });
    });
});

// Toggle likes for a specific content
router.put('/:id/likes', (req, res) => {
    const contentId = req.params.id;
    const { isLiking } = req.body;

    const sql = 'UPDATE educationcontent SET contentLikes = contentLikes + ? WHERE contentId = ?';
    const increment = isLiking ? 1 : -1;

    db.query(sql, [increment, contentId], (err, result) => {
        if (err) {
            console.error('Error updating likes:', err);
            res.status(500).send('Error updating likes');
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).send('Content not found');
            return;
        }
        res.json({
            success: true,
            message: 'Likes updated successfully',
            isLiked: isLiking
        });
    });
});

// Add new education content
router.post('/', (req, res) => {
    const {
        contentTitle,
        contentDescription,
        contentFull,
        contentImage
    } = req.body;

    if (!contentTitle || !contentDescription || !contentFull) {
        res.status(400).send('Missing required fields');
        return;
    }

    const content = {
        contentTitle,
        contentDescription,
        contentFull,
        contentImage,
        contentViews: 0,
        contentLikes: 0,
        timestamp: new Date()
    };

    let sql = 'INSERT INTO educationcontent SET ?';

    db.query(sql, content, (err, result) => {
        if (err) {
            console.error('Error creating education content:', err);
            res.status(500).send('Error creating education content');
            return;
        }
        res.status(201).json({
            success: true,
            message: 'Content created successfully',
            contentId: result.insertId
        });
    });
});

// Update education content
router.put('/:id', (req, res) => {
    const contentId = req.params.id;
    const {
        contentTitle,
        contentDescription,
        contentFull,
        contentImage
    } = req.body;

    if (!contentTitle && !contentDescription && !contentFull && !contentImage) {
        res.status(400).send('No fields to update');
        return;
    }

    let updateFields = {};
    if (contentTitle) updateFields.contentTitle = contentTitle;
    if (contentDescription) updateFields.contentDescription = contentDescription;
    if (contentFull) updateFields.contentFull = contentFull;
    if (contentImage) updateFields.contentImage = contentImage;

    let sql = 'UPDATE educationcontent SET ? WHERE contentId = ?';

    db.query(sql, [updateFields, contentId], (err, result) => {
        if (err) {
            console.error('Error updating education content:', err);
            res.status(500).send('Error updating education content');
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).send('Content not found');
            return;
        }
        res.json({ success: true, message: 'Content updated successfully' });
    });
});

// Delete education content
router.delete('/:id', (req, res) => {
    const contentId = req.params.id;
    let sql = 'DELETE FROM educationcontent WHERE contentId = ?';

    db.query(sql, [contentId], (err, result) => {
        if (err) {
            console.error('Error deleting education content:', err);
            res.status(500).send('Error deleting education content');
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).send('Content not found');
            return;
        }
        res.json({ success: true, message: 'Content deleted successfully' });
    });
});

module.exports = router;