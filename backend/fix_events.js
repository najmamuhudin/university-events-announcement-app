const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '.env') });

const Event = require('./models/Event');

const fixEvents = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        // Use the image I just uploaded successfully
        const imageUrl = '/uploads/image-1769885392563.png';
        const result = await Event.updateMany(
            { imageUrl: { $eq: null } },
            { $set: { imageUrl: imageUrl } }
        );
        console.log(`Updated ${result.modifiedCount} events`);
        await mongoose.connection.close();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

fixEvents();
