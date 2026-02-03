const jwt = require('jsonwebtoken');
const asyncHandler = require('express-async-handler');
const User = require('../models/User');

/**
 * Middleware to protect routes.
 * Verifies the JWT token from the Authorization header.
 * If valid, attaches the user object to req.user.
 */
const protect = asyncHandler(async (req, res, next) => {
    let token;

    // Check for Authorization header starting with 'Bearer'
    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')
    ) {
        try {
            // Get token from header (Bearer <token>)
            token = req.headers.authorization.split(' ')[1];

            // Verify the token using the secret key
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // Get user from the token payload (id) and attach to request
            // Exclude the password using .select('-password')
            req.user = await User.findById(decoded.id).select('-password');

            next(); // Proceed to the next middleware/controller
        } catch (error) {
            console.log(error);
            res.status(401);
            throw new Error('Not authorized');
        }
    }

    if (!token) {
        res.status(401);
        throw new Error('Not authorized, no token');
    }
});

/**
 * Middleware to restrict access to Admins only.
 * Must be used after 'protect' middleware.
 */
const admin = (req, res, next) => {
    if (req.user && req.user.role === 'admin') {
        next();
    } else {
        res.status(401);
        throw new Error('Not authorized as an admin');
    }
};

module.exports = { protect, admin };