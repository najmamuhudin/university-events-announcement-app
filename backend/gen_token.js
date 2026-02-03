const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({ path: path.join(__dirname, '.env') });

const token = jwt.sign({ id: '69774caf1a4a4b4aa42a2b33' }, process.env.JWT_SECRET, {
    expiresIn: '30d'
});

console.log(token);
