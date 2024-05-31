import express from 'express';
import authenticateToken from '../auth/authenticate_token.js';
import Favorites from '../../models/favorites/fav_model.js';
import Poem from '../../models/poem/poem_model.js';

const favRouter = express.Router();

favRouter.get('/api/favorites', async (req, res) => {
    try {
      const userId = req.query.userId; 
      const favorites = await Favorites.findOne({ userId }).populate('poems');
        console.log(`fav ${favorites}`);
        
      res.status(200).json(favorites ? favorites.poems : []);
    } catch (error) {
      console.error('Error getting favorites:', error);
      res.status(500).json({ message: 'Internal server error.' });
    }
  });
favRouter.post('/api/favorites', async (req, res) => {
    try {
      const { poemId , userId} = req.body;
  
      const poem = await Poem.findById(poemId);
  
      if (!poem) {
        return res.status(404).json({ message: 'Poem not found' });
      }
  
      const favorite = await Favorites.findOneAndUpdate(
        { userId: userId },
          { $addToSet: { poems: { userId, poemId } } },
        { upsert: true, new: true }
      );
  
      res.status(201).json(favorite.poems.slice(3));
    } catch (error) {
      console.error('Error adding poem to favorites:', error);
      res.status(500).json({ message: 'Internal server error.' });
    }
  });
  favRouter.delete('/api/favorites', async (req, res) => {
    try {
        const { poemId, userId } = req.query; // Extract poemId and userId directly from req.query
        console.log('PoemId:', poemId);
        console.log('UserId:', userId);

        const favorite = await Favorites.findOneAndUpdate(
            { userId: userId },
            { $pull: { poems: { poemId } } },
            { new: true }
        );

        res.status(200).json(favorite.poems);
    } catch (error) {
        console.error('Error removing poem from favorites:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});



export default favRouter;