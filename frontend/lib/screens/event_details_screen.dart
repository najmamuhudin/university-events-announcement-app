import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final String title = event['title'] ?? 'Event Details';
    final String date = event['date'] ?? 'Upcoming';
    final String time = event['time'] ?? 'TBA';
    final String location = event['location'] ?? 'Campus';
    final String category = event['category'] ?? 'EVENT';

    final String description =
        event['description'] ?? 'No description available for this event.';

    final user = Provider.of<AuthProvider>(context).user;
    final userId = user?['_id'];
    final attendees = (event['attendees'] as List?) ?? [];
    final bool isRegistered = userId != null && attendees.contains(userId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. App Bar with Image
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  background: ImageHelper.buildNetworkImage(
                    event['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Chips layer
                      Row(
                        children: [
                          _buildChip(
                            category,
                            const Color(0xFF3A4F9B).withOpacity(0.1),
                            const Color(0xFF3A4F9B),
                          ),
                          const SizedBox(width: 8),
                          _buildChip(
                            'OPEN FOR ALL',
                            const Color(0xFFE8F5E9),
                            const Color(0xFF4CAF50),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Date & Time Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[100]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A4F9B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xFF3A4F9B),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$date • $time',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    location,
                                    style: GoogleFonts.inter(
                                      color: Colors.grey[500],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'About Event',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF5A6B87),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 100), // Space for fixed button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Fixed Bottom Button
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: ElevatedButton(
              onPressed: isRegistered
                  ? null
                  : () async {
                      try {
                        final eventId = event['_id'] ?? event['id'];
                        if (eventId == null) {
                          throw Exception('Invalid event ID');
                        }
                        await Provider.of<EventProvider>(
                          context,
                          listen: false,
                        ).registerForEvent(eventId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registered successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isRegistered ? Colors.grey : const Color(0xFF3A4F9B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: isRegistered
                    ? Colors.transparent
                    : const Color(0xFF3A4F9B).withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRegistered ? 'Already Registered' : 'Register Now',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isRegistered) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
