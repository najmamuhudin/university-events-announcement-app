const asyncHandler = require('express-async-handler');
const Event = require('../models/Event');
const User = require('../models/User');

/**
 * @desc    Get all events
 * @route   GET /api/events
 * @access  Public
 * @returns {Array} List of all events sorted by creation date (newest first)
 */
const getEvents = asyncHandler(async (req, res) => {
    // Fetch events from MongoDB and sort them by createdAt in descending order (-1)
    const events = await Event.find().sort({ createdAt: -1 });
    res.status(200).json(events);
});

/**
 * @desc    Create new event
 * @route   POST /api/events
 * @access  Private (Admin only)
 * @param   {Object} req.body - Event details (title, date, time, location, description, category, imageUrl)
 */
const createEvent = asyncHandler(async (req, res) => {
    // Logging for debugging incoming request data
    console.log('--- CREATING EVENT ---');
    console.log('User:', req.user.id);
    console.log('Title:', req.body.title);

    const { title, date, time, location, description, category, imageUrl } = req.body;

    // Validate that all required fields are present
    if (!title || !date || !time || !location || !description || !category) {
        res.status(400);
        throw new Error('Please add all text fields');
    }

    // Create the event in the database associated with the logged-in admin user
    const event = await Event.create({
        user: req.user.id,
        title,
        date,
        time,
        location,
        description,
        category,
        imageUrl // detailed image URL or path
    });

    res.status(201).json(event);
});

/**
 * @desc    Update an existing event
 * @route   PUT /api/events/:id
 * @access  Private (Admin only)
 * @param   {String} req.params.id - The ID of the event to update
 */
const updateEvent = asyncHandler(async (req, res) => {
    // Find the event by ID
    const event = await Event.findById(req.params.id);

    // If event not found, throw 404 error
    if (!event) {
        res.status(404);
        throw new Error('Event not found');
    }

    // Verify user exists in request (handled by protect middleware, but double check)
    if (!req.user) {
        res.status(401);
        throw new Error('User not found');
    }

    // Authorization check: Ensure the user is an admin
    if (req.user.role !== 'admin') {
        res.status(401);
        throw new Error('User not authorized');
    }

    // Update the event with the new data from req.body
    // { new: true } ensures the updated document is returned
    const updatedEvent = await Event.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
    });

    res.status(200).json(updatedEvent);
});

/**
 * @desc    Delete an event
 * @route   DELETE /api/events/:id
 * @access  Private (Admin only)
 * @param   {String} req.params.id - The ID of the event to delete
 */
const deleteEvent = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id);

    if (!event) {
        res.status(404);
        throw new Error('Event not found');
    }

    // Check for user existence
    if (!req.user) {
        res.status(401);
        throw new Error('User not found');
    }

    // Authorization check: Ensure user is admin before deleting
    if (req.user.role !== 'admin') {
        res.status(401);
        throw new Error('User not authorized');
    }

    // Perform the deletion
    await event.deleteOne();

    res.status(200).json({ id: req.params.id });
});

/**
 * @desc    Register a user for an event
 * @route   POST /api/events/:id/register
 * @access  Private (Students/Admins)
 * @param   {String} req.params.id - The ID of the event
 */
const registerForEvent = asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id);

    if (!event) {
        res.status(404);
        throw new Error('Event not found');
    }

    // Check if the user's ID is already in the event's attendees list
    if (event.attendees.includes(req.user.id)) {
        res.status(400);
        throw new Error('User already registered for this event');
    }

    // Add user ID to attendees array and save
    event.attendees.push(req.user.id);
    await event.save();

    res.status(200).json({ message: 'Registered successfully', event });
});

module.exports = {
    getEvents,
    createEvent,
    updateEvent,
    deleteEvent,
    registerForEvent,
};