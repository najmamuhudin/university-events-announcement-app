const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const User = require('../models/User');

const seedAdmin = async () => {
    try {
        const adminEmail = 'admin@gmail.com';
        const userExists = await User.findOne({ email: adminEmail });

        if (!userExists) {
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash('admin123', salt);

            await User.create({
                name: 'System Admin',
                email: adminEmail,
                password: hashedPassword,
                studentId: 'ADMIN001',
                role: 'admin'
            });

            console.log('Admin user seeded successfully');
        } else {
            // Optional: Ensure it has admin role if it exists (in case it was created differently)
            if (userExists.role !== 'admin') {
                userExists.role = 'admin';
                await userExists.save();
                console.log('Existing user updated to admin role');
            }
        }

        // Seed Student
        const studentEmail = 'student@gmail.com';
        const studentExists = await User.findOne({ email: studentEmail });

        if (!studentExists) {
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash('student123', salt);

            await User.create({
                name: 'Alex Johnson',
                email: studentEmail,
                password: hashedPassword,
                studentId: '2024-0891',
                role: 'student',
                department: 'Computer Science',
                year: 'Senior'
            });

            console.log('Student user seeded successfully');
        }
    } catch (error) {
        console.error('Error seeding admin user:', error);
    }
};

module.exports = seedAdmin;