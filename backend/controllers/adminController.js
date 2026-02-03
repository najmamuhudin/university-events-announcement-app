const User = require('../models/User');
const Event = require('../models/Event');
const Inquiry = require('../models/Inquiry');
const Announcement = require('../models/Announcement');

/**
 * @desc    Get dashboard stats
 * @route   GET /api/admin/stats
 * @access  Private/Admin
 * @returns {Object} JSON object containing totalStudents, activeEvents, pendingInquiries, and recentActivity list
 */
const getDashboardStats = async (req, res) => {
    try {
        // Count total number of students
        const totalStudents = await User.countDocuments({ role: 'student' });
        // Count total number of events
        const activeEvents = await Event.countDocuments();
        // Count inquiries that are still pending
        const pendingInquiries = await Inquiry.countDocuments({ status: 'PENDING' });

        // Get recent 5 events to show in activity feed
        const recentEvents = await Event.find().sort({ createdAt: -1 }).limit(5).populate('user', 'name');
        // Get recent 5 inquiries to show in activity feed
        const recentInquiries = await Inquiry.find().sort({ createdAt: -1 }).limit(5).populate('user', 'name');

        // Combined Recent Activity Feed
        const recentActivity = [];

        // Format recent events for the feed
        recentEvents.forEach(event => {
            recentActivity.push({
                type: 'event',
                title: event.title,
                subtitle: `Event created by ${event.user?.name || 'Admin'}`,
                time: event.createdAt,
                icon: 'event'
            });
        });

        // Format recent inquiries for the feed
        recentInquiries.forEach(inquiry => {
            recentActivity.push({
                type: 'inquiry',
                title: inquiry.subject,
                subtitle: `Inquiry from ${inquiry.user?.name || 'Student'}`,
                time: inquiry.createdAt,
                icon: 'chat'
            });
        });

        // Sort the combined activity by time (newest first)
        recentActivity.sort((a, b) => b.time - a.time);

        res.json({
            totalStudents,
            activeEvents,
            pendingInquiries,
            recentActivity: recentActivity.slice(0, 5) // Return only the top 5 most recent activities
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Get all registered students
 * @route   GET /api/admin/students
 * @access  Private/Admin
 * @returns {Array} List of students with their details
 */
const getAllStudents = async (req, res) => {
    try {
        const students = await User.find({ role: 'student' })
            .select('-password')
            .sort({ createdAt: -1 });
        res.json(students);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getDashboardStats,
    getAllStudents
};
