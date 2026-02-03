const mongoose = require('mongoose');

const announcementSchema = mongoose.Schema({
    title: { type: String, required: true },
    message: { type: String, required: true },
    urgent: { type: Boolean, default: false },
    audience: { type: String, default: 'All Students' },
    admin: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
}, {
    timestamps: true
});

module.exports = mongoose.model('Announcement', announcementSchema);