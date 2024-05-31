import mongoose from "mongoose";

const favSchema = mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
    },
    PoemId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    poems: [{
        
        userId: {
            type: mongoose.Schema.Types.ObjectId,
        },
        poemId: {
            type: mongoose.Schema.Types.ObjectId,
        }
        
    }]
});

const Favorites = mongoose.model("Favorites", favSchema);

export default Favorites;