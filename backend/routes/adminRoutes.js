const express = require('express');
const router = express.Router();
const { getDashboardStats, getAllStudents } = require('../controllers/adminController');
const { protect, admin } = require('../middleware/authMiddleware');

router.get('/stats', protect, admin, getDashboardStats);
router.get('/students', protect, admin, getAllStudents);

module.exports = router;
