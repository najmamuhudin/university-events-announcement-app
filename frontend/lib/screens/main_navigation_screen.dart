import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'home_screen.dart';
import 'inquiries_screen.dart';
import 'profile_screen.dart';
import 'announcements_screen.dart';
import 'events_list_screen.dart';
import 'admin_events_screen.dart';
import 'student_messages_screen.dart'; // New Screen
import '../providers/navigation_provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final int currentIndex = navProvider.currentIndex;
    final user = Provider.of<AuthProvider>(context).user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isAdmin = user['role'] == 'admin';

    // Updated lists: Admin navigation remains same, Student gets "Messages" section
    final List<Widget> screens = isAdmin
        ? [
            const DashboardScreen(),
            const AnnouncementsScreen(), // Added
            const AdminEventsScreen(),
            const InquiriesScreen(),
            const ProfileScreen(),
          ]
        : [
            const HomeScreen(),
            const EventsListScreen(),
            const AnnouncementsScreen(),
            const StudentMessagesScreen(), // Added Messages Section
            const ProfileScreen(),
          ];

    final List<BottomNavigationBarItem> navItems = isAdmin
        ? const [
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined), // Changed
              label: "Updates",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: "My Events",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              label: "Inbox",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ]
        : const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: "Events",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              label: "Updates",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), // Messages Icon
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ];

    if (currentIndex >= screens.length) {
      navProvider.setIndex(0);
      return const SizedBox();
    }

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => navProvider.setIndex(index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3A4F9B),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10, // Adjusted for 5 items
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: navItems,
        ),
      ),
    );
  }
}
