const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '.env') });

const Event = require('./models/Event');

const dumpEvents = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        const events = await Event.find();
        console.log(JSON.stringify(events, null, 2));
        await mongoose.connection.close();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

dumpEvents();
