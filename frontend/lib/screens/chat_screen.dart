import 'package:flutter/material.dart';
import 'package:frontend/utils/theme.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Student Affairs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                Icon(Icons.circle, size: 8, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Date Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'TODAY',
                style: TextStyle(
                  color: AppTheme.subtitleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _ChatBubble(
                  isMe: false,
                  message:
                      'Hello! Welcome to the University Support Center. How can we help you with your event registration today?',
                  time: '10:15 AM',
                  sender: 'Student Affairs',
                ),
                _ChatBubble(
                  isMe: true,
                  message:
                      'I have a question about the document requirements for the upcoming campus career fair. Do I need to upload my resume now?',
                  time: '10:18 AM',
                  sender: 'Me',
                ),
                _ChatBubble(
                  isMe: false,
                  message:
                      'Yes, please. We also need a copy of your current student ID for verification. You can attach it right here.',
                  time: '10:20 AM',
                  sender: 'Student Affairs',
                  avatarUrl: 'https://i.pravatar.cc/100?img=5',
                ),
                _ChatBubble(
                  isMe: true,
                  message: 'Sure, here is my current student ID.',
                  time: '10:22 AM',
                  sender: 'Me',
                ),
                _ImageBubble(),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.more_horiz, color: Color(0xFF3A4F9B)),
                        SizedBox(width: 8),
                        Text(
                          "Admin is typing...",
                          style: TextStyle(
                            color: Color(0xFF3A4F9B),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildActionChip('Check status'),
                const SizedBox(width: 8),
                _buildActionChip('Opening hours'),
                const SizedBox(width: 8),
                _buildActionChip('Contact Registration'),
              ],
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Type a message...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(color: AppTheme.primaryColor)),
      backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final String sender;
  final String? avatarUrl;

  const _ChatBubble({
    required this.isMe,
    required this.message,
    required this.time,
    required this.sender,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (!isMe) ...[
          Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 4),
            child: Text(
              '$sender • $time',
              style: TextStyle(
                color: AppTheme.subtitleColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(right: 0, bottom: 4),
            child: Text(
              '$sender • $time',
              style: TextStyle(
                color: AppTheme.subtitleColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF2D3142), // Dark, almost black
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? const SizedBox()
                    : null, // Empty for now if no url
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMe ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                  ),
                  boxShadow: [
                    if (!isMe)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Text(
                  message,
                  style: isMe
                      ? const TextStyle(color: Colors.white)
                      : const TextStyle(color: Colors.black87),
                ),
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 8),
              // Avatar removed to match screenshot
            ],
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ImageBubble extends StatelessWidget {
  const _ImageBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40,
        right: 0,
        bottom: 16,
      ), // Offset for avatar
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.orangeAccent],
          ),
        ),
        child: Stack(
          children: [
            // Mock ID card visual
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 4,
                            width: 40,
                            color: Colors.black26,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 4,
                            width: 60,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 50,
                      color: const Color(0xFF3A4F9B).withOpacity(0.1),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
