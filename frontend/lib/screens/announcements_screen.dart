import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import 'post_announcement_screen.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Campus Updates',
          style: GoogleFonts.merriweather(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false).setIndex(0);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<AdminProvider>(
            context,
            listen: false,
          ).fetchAnnouncements();
        },
        child: Consumer<AdminProvider>(
          builder: (context, adminProvider, _) {
            if (adminProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (adminProvider.announcements.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No updates available",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            final isAdmin = Provider.of<AuthProvider>(context, listen: false)
                    .user?['role'] ==
                'admin';
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: adminProvider.announcements.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final announcement = adminProvider.announcements[index];
                return _buildAnnouncementCard(announcement, isAdmin);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(dynamic announcement, bool isAdmin) {
    final title = announcement['title'] ?? 'Untitled';
    final message = announcement['message'] ?? '';
    final createdAt = announcement['createdAt'];
    final time = _formatTime(createdAt);
    final isUrgent = announcement['urgent'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isUrgent
                ? Colors.red.withOpacity(0.1)
                : const Color(0xFF3A4F9B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isUrgent ? 'URGENT' : 'CAMPUS',
            style: TextStyle(
              color: isUrgent ? Colors.red : const Color(0xFF3A4F9B),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                if (isAdmin)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostAnnouncementScreen(
                                announcement: announcement),
                          ),
                        );
                      } else if (value == 'delete') {
                        _showDeleteAnnouncementDialog(
                            context, announcement['_id'], title);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 20, color: Colors.amber),
                            SizedBox(width: 8),
                            Text('Update'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 20, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return '';
    }
  }

  void _showDeleteAnnouncementDialog(
      BuildContext context, String? id, String title) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Announcement"),
        content: Text("Are you sure you want to delete '$title'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await Provider.of<AdminProvider>(context, listen: false)
                    .deleteAnnouncement(id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Announcement deleted")),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
