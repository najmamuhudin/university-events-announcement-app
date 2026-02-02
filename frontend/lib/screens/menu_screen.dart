import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import 'login_screen.dart';
import 'chat_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    const Color mainBlue = Color(0xFF3A4F9B);

    return Scaffold(
      backgroundColor: mainBlue,
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RESTORED: Profile Section from your original data
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      user?['profileImage'] ??
                          'https://i.pravatar.cc/150?u=student',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?['name'] ?? 'naima abdi aziiz',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?['email'] ?? 'naima@gmail.com',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const SizedBox(
              width: 200,
              child: Divider(color: Colors.white24, thickness: 1),
            ),
            const SizedBox(height: 10),

            // RESTORED: Original Menu Labels with matching style
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(context, Icons.home_outlined, 'Home', 0),
                  _buildActionItem(context, Icons.info_outline, 'About', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                    ZoomDrawer.of(context)?.close();
                  }),
                  _buildMenuItem(context, Icons.event_note, 'Event', 1),
                  _buildMenuItem(
                    context,
                    Icons.campaign_outlined,
                    'Announcements',
                    2,
                  ),
                  _buildMenuItem(context, Icons.message_outlined, 'Message', 3),
                  _buildActionItem(
                    context,
                    Icons.phone_outlined,
                    'Contact',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactScreen(),
                        ),
                      );
                      ZoomDrawer.of(context)?.close();
                    },
                  ),

                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 200,
                    child: Divider(color: Colors.white24, thickness: 1),
                  ),
                  const SizedBox(height: 10),

                  _buildActionItem(
                    context,
                    Icons.logout_rounded,
                    'Log Out',
                    () {
                      Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: () {
        final nav = Provider.of<NavigationProvider>(context, listen: false);
        ZoomDrawer.of(context)?.close();
        nav.setIndex(index);
      },
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      onTap: onTap,
    );
  }
}
