const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '.env') });

const User = require('./models/User');

const dumpUsers = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        const users = await User.find();
        console.log(JSON.stringify(users, null, 2));
        await mongoose.connection.close();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

dumpUsers();
