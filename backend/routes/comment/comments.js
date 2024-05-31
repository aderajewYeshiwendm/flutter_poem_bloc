import express from 'express';
import Comment from '../../models/comments/comment_model.js';
import authenticateToken from '../auth/authenticate_token.js';
const commentRouter = express.Router();

commentRouter.post('/api/comments', async (req, res) => {
    try {
        const { content, username, poemId } = req.body;
        if (!content) {
            return res.status(400).json({ message: 'Comment, username, and poemId are required.' });
        }
        const newComment = new Comment({ content, username, poemId });
        await newComment.save();
        res.status(201).json({ message: 'Comment created successfully.', content: newComment,username: username });
    } catch (error) {
        console.error('Error creating comment:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});

commentRouter.get('/api/comments', async (req, res) => {
    try {
        const { poemId } = req.query;
        if (!poemId) {
            return res.status(400).json({ message: 'poemId is required.' });
        }
        const comments = await Comment.find({ poemId });
        

        res.status(200).json(comments);
    } catch (error) {
        console.error('Error fetching comments:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});


export default commentRouter;
