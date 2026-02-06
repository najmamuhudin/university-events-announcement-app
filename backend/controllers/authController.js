const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const asyncHandler = require('express-async-handler');
const User = require('../models/User');

/**
 * @desc    Register new user
 * @route   POST /api/auth/register
 * @access  Public
 * @param   {Object} req.body - Contains name, email, password, studentId, etc.
 */
const registerUser = asyncHandler(async (req, res) => {
    const { name, email, password, studentId } = req.body;

    // Validate required fields
    if (!name || !email || !password || !studentId) {
        res.status(400);
        throw new Error('Please add all fields');
    }

    // Check if a user with this email already exists
    const userExists = await User.findOne({ email });
    if (userExists) {
        res.status(400);
        throw new Error('User with this email already exists');
    }

    // Check if a user with this student ID already exists
    const idExists = await User.findOne({ studentId });
    if (idExists) {
        res.status(400);
        throw new Error('A user with this ID Number already exists');
    }

    // Password Hashing: Generate salt and hash the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Default role assignment
    const role = 'student';

    // Create the new user in the database
    const user = await User.create({
        name,
        email,
        password: hashedPassword, // Store hashed password for security
        studentId,
        role,
        department: req.body.department || 'General',
        year: req.body.year || 'Freshman'
    });

    if (user) {
        res.status(201).json({
            _id: user.id,
            name: user.name,
            email: user.email,
            studentId: user.studentId,
            role: user.role,
            token: generateToken(user._id) // Return JWT for immediate login
        });
    } else {
        res.status(400);
        throw new Error('Invalid user data');
    }
});

/**
 * @desc    Authenticate a user (Login)
 * @route   POST /api/auth/login
 * @access  Public
 * @param   {Object} req.body - email and password
 */
const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    // Check for user by email
    const user = await User.findOne({ email });

    // Compare provided password with hashed password in DB
    if (user && (await bcrypt.compare(password, user.password))) {
        res.json({
            _id: user.id,
            name: user.name,
            email: user.email,
            studentId: user.studentId,
            role: user.role,
            token: generateToken(user._id)
        });
    } else {
        res.status(401);
        throw new Error('Invalid credentials');
    }
});

/**
 * @desc    Get current logged-in user data
 * @route   GET /api/auth/me
 * @access  Private
 */
const getMe = asyncHandler(async (req, res) => {
    // Returns the user data attached to req by the protect middleware
    res.status(200).json(req.user);
});

/**
 * @desc    Forgot Password Request
 * @route   POST /api/auth/forgot-password
 * @access  Public
 */
const forgotPassword = asyncHandler(async (req, res) => {
    const { email, studentId } = req.body;

    const user = await User.findOne({ email, studentId });

    if (!user) {
        res.status(404);
        throw new Error('User not found with these details');
    }

    // Since we don't have an email server, we'll return a "Security Code"
    // In a real app, this would be emailed as a link.
    res.json({
        message: 'Identity verified. You can now reset your password.',
        token: user._id // Simple demo token: using User ID as the override permission
    });
});

/**
 * @desc    Reset Password
 * @route   POST /api/auth/reset-password
 * @access  Public
 */
const resetPassword = asyncHandler(async (req, res) => {
    const { token, newPassword } = req.body;

    const user = await User.findById(token);

    if (!user) {
        res.status(400);
        throw new Error('Invalid reset token');
    }

    // Hash the new password
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(newPassword, salt);
    await user.save();

    res.json({ message: 'Password reset successful' });
});

/**
 * Generate JWT Token
 * @param {string} id - User ID
 * @returns {string} JWT Token
 */
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: '30d', // Token expires in 30 days
    });
};

module.exports = {
    registerUser,
    loginUser,
    forgotPassword,
    resetPassword,
    getMe,
};