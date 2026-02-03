import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../providers/admin_provider.dart';
import 'package:intl/intl.dart';
import 'create_event_screen.dart';
import 'post_announcement_screen.dart';
import '../providers/navigation_provider.dart';
import 'registered_students_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
      Provider.of<AdminProvider>(context, listen: false).fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    if (user == null) return const SizedBox();

    final bool isAdmin = user['role'] == 'admin';

    if (!isAdmin) {
      return _buildStudentDashboard(context, user);
    }

    final adminProvider = Provider.of<AdminProvider>(context);
    final stats = adminProvider.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => adminProvider.fetchStats(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _sectionTitle("Key Metrics"),
              const SizedBox(height: 12),
              _buildMetrics(stats),
              const SizedBox(height: 16),
              _buildPendingCard(stats),
              const SizedBox(height: 24),
              _sectionTitle("Quick Actions"),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _sectionTitle("Engagement Overview"),
              const SizedBox(height: 12),
              _buildChart(),
              const SizedBox(height: 24),
              _sectionTitle("Recent Activity"),
              const SizedBox(height: 12),
              _buildRecentActivity(stats),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFF3A4F9B),
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Admin Dashboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  // ================= METRICS =================
  Widget _buildMetrics(Map<String, dynamic>? stats) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisteredStudentsScreen(),
                ),
              );
            },
            child: _metricCard(
              title: "Total Students",
              value: stats?['totalStudents']?.toString() ?? "12,450",
              subtitle: stats != null ? "Registered" : "+2.4%",
              icon: Icons.groups,
              subtitleColor: Colors.green,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false)
                  .setIndex(2);
            },
            child: _metricCard(
              title: "Active Events",
              value: stats?['activeEvents']?.toString() ?? "18",
              subtitle: "Live Now",
              icon: Icons.calendar_today,
              subtitleColor: Color(0xFF3A4F9B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: _greyText()),
              Icon(icon, color: Color(0xFF3A4F9B)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PENDING =================
  Widget _buildPendingCard(Map<String, dynamic>? stats) {
    return InkWell(
      onTap: () {
        Provider.of<NavigationProvider>(context, listen: false).setIndex(3);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pending Inquiries",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  stats?['pendingInquiries']?.toString() ?? "5",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE7C2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "HIGH PRIORITY",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= QUICK ACTIONS =================
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3A4F9B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PostAnnouncementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.campaign, color: Colors.white),
            label: const Text(
              "Post Announcement",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateEventScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Create New Event"),
          ),
        ),
      ],
    );
  }

  // ================= CHART =================
  Widget _buildChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = [
                    "MON",
                    "TUE",
                    "WED",
                    "THU",
                    "FRI",
                    "SAT",
                    "SUN",
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      value.toInt() >= 0 && value.toInt() < days.length
                          ? days[value.toInt()]
                          : '',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(
            7,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (i + 2).toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  color: i == 5
                      ? Color(0xFF3A4F9B)
                      : Color(0xFF3A4F9B).withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= RECENT ACTIVITY =================
  Widget _buildRecentActivity(Map<String, dynamic>? stats) {
    final activities = stats?['recentActivity'] as List<dynamic>?;

    if (activities == null || activities.isEmpty) {
      return Column(
        children: [
          const _ActivityTile(
            icon: Icons.check_circle,
            iconColor: Color(0xFF3A4F9B),
            title: "Annual Career Fair",
            subtitle: "Event approved and published by Admin Sarah",
            time: "2 hours ago",
          ),
          const SizedBox(height: 12),
          const _ActivityTile(
            icon: Icons.chat,
            iconColor: Colors.purple,
            title: "New Support Inquiry",
            subtitle: "Student ID #4421 requested room change details",
            time: "5 hours ago",
          ),
        ],
      );
    }

    return Column(
      children: activities.map((activity) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _ActivityTile(
            icon: activity['icon'] == 'event' ? Icons.check_circle : Icons.chat,
            iconColor:
                activity['icon'] == 'event' ? Color(0xFF3A4F9B) : Colors.purple,
            title: activity['title'] ?? "Untitled",
            subtitle: activity['subtitle'] ?? "",
            time: _formatTime(activity['time']),
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) return "";
    try {
      final dateTime = DateTime.parse(timeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return "${difference.inMinutes} minutes ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else {
        return DateFormat('MMM d, h:mm a').format(dateTime);
      }
    } catch (e) {
      return timeStr;
    }
  }

  // ================= STUDENT DASHBOARD (unchanged logic, styled) =================
  Widget _buildStudentDashboard(
    BuildContext context,
    Map<String, dynamic> user,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome Banner
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3A4F9B), Color(0xFF1E2F6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF3A4F9B).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${user['name']}!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Discover what's happening around your campus today.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _sectionTitle("Upcoming Events"),
        const SizedBox(height: 16),
        Consumer<EventProvider>(
          builder: (context, eventProvider, _) {
            if (eventProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (eventProvider.events.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_note_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No events yet.\nCheck back later!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: eventProvider.events
                  .map((event) => _buildEventTile(context, event))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventTile(BuildContext context, dynamic event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Color(0xFF3A4F9B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_available,
              color: Color(0xFF3A4F9B),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] ?? "Untitled Event",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event['date'] ?? "",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        event['location'] ?? "TBD",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );

  TextStyle _greyText() => const TextStyle(color: Colors.grey, fontSize: 13);

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

// ================= ACTIVITY TILE =================
class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
