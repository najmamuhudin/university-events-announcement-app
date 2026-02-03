const asyncHandler = require('express-async-handler');
const Announcement = require('../models/Announcement');

/**
 * @desc    Get all announcements
 * @route   GET /api/announcements
 * @access  Private
 * @returns {Array} List of announcements sorted by creation date (newest first)
 */
const getAnnouncements = asyncHandler(async (req, res) => {
    // Fetch all announcements from the database
    // sort({ createdAt: -1 }) ensures the latest announcements appear first
    const announcements = await Announcement.find().sort({ createdAt: -1 });
    res.status(200).json(announcements);
});

/**
 * @desc    Create a new announcement
 * @route   POST /api/announcements
 * @access  Private (Admin only)
 * @param   {Object} req.body - Contains title, message, urgent, and audience
 */
const createAnnouncement = asyncHandler(async (req, res) => {
    const { title, message, urgent, audience } = req.body;

    // Validate required fields (assumes title and message are mandatory)
    if (!title || !message) {
        res.status(400);
        throw new Error('Please add a title and message');
    }

    // Create the announcement linked to the creating admin user
    const announcement = await Announcement.create({
        title,
        message,
        urgent,
        audience,
        admin: req.user._id // req.user is set by the protect middleware
    });

    res.status(201).json(announcement);
});

/**
 * @desc    Update an existing announcement
 * @route   PUT /api/announcements/:id
 * @access  Private (Admin only)
 * @param   {String} req.params.id - The ID of the announcement to update
 */
const updateAnnouncement = asyncHandler(async (req, res) => {
    const announcement = await Announcement.findById(req.params.id);

    if (!announcement) {
        res.status(404);
        throw new Error('Announcement not found');
    }

    // Update the announcement
    // { new: true } returns the modified document rather than the original
    const updatedAnnouncement = await Announcement.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true }
    );

    res.status(200).json(updatedAnnouncement);
});

/**
 * @desc    Delete an announcement
 * @route   DELETE /api/announcements/:id
 * @access  Private (Admin only)
 * @param   {String} req.params.id - The ID of the announcement to delete
 */
const deleteAnnouncement = asyncHandler(async (req, res) => {
    const announcement = await Announcement.findById(req.params.id);

    if (!announcement) {
        res.status(404);
        throw new Error('Announcement not found');
    }

    await announcement.deleteOne();

    res.status(200).json({ message: 'Announcement removed', id: req.params.id });
});

module.exports = {
    getAnnouncements,
    createAnnouncement,
    updateAnnouncement,
    deleteAnnouncement,
};
