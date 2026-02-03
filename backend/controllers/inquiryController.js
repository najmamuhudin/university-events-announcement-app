const asyncHandler = require('express-async-handler');
const Inquiry = require('../models/Inquiry');

/**
 * @desc    Get all inquiries
 * @route   GET /api/inquiries
 * @access  Private (Admin only)
 * @returns {Array} List of inquiries sorted by creation date, with user details populated
 */
const getInquiries = asyncHandler(async (req, res) => {
    // Fetch all inquiries, populate user details (name, email), and sort by newest first
    const inquiries = await Inquiry.find()
        .populate('user', 'name email')
        .sort({ createdAt: -1 });
    res.status(200).json(inquiries);
});

/**
 * @desc    Create a new inquiry
 * @route   POST /api/inquiries
 * @access  Private (Students)
 * @param   {Object} req.body - Contains subject and message
 */
const createInquiry = asyncHandler(async (req, res) => {
    const { subject, message } = req.body;

    // Create inquiry linked to the logged-in user
    const inquiry = await Inquiry.create({
        user: req.user._id,
        subject,
        message
    });

    res.status(201).json(inquiry);
});

/**
 * @desc    Mark an inquiry as resolved
 * @route   PUT /api/inquiries/:id
 * @access  Private (Admin only)
 * @param   {String} req.params.id - The ID of the inquiry to resolve
 */
const resolveInquiry = asyncHandler(async (req, res) => {
    const inquiry = await Inquiry.findById(req.params.id);

    if (inquiry) {
        // Update status to RESOLVED
        inquiry.status = 'RESOLVED';
        await inquiry.save();
        res.status(200).json(inquiry);
    } else {
        res.status(404);
        throw new Error('Inquiry not found');
    }
});

/**
 * @desc    Delete an inquiry
 * @route   DELETE /api/inquiries/:id
 * @access  Private (Admin only)
 * @param   {String} req.params.id - The ID of the inquiry to delete
 */
const deleteInquiry = asyncHandler(async (req, res) => {
    const inquiry = await Inquiry.findById(req.params.id);

    if (inquiry) {
        await inquiry.deleteOne();
        res.status(200).json({ message: 'Inquiry removed' });
    } else {
        res.status(404);
        throw new Error('Inquiry not found');
    }
});

module.exports = {
    getInquiries,
    createInquiry,
    resolveInquiry,
    deleteInquiry,
};
