import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class RegisteredStudentsScreen extends StatefulWidget {
  const RegisteredStudentsScreen({super.key});

  @override
  State<RegisteredStudentsScreen> createState() =>
      _RegisteredStudentsScreenState();
}

class _RegisteredStudentsScreenState extends State<RegisteredStudentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registered Students",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminProvider.error != null
              ? Center(child: Text('Error: ${adminProvider.error}'))
              : adminProvider.students.isEmpty
                  ? const Center(child: Text("No students found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: adminProvider.students.length,
                      itemBuilder: (context, index) {
                        final student = adminProvider.students[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF3A4F9B),
                              child: Text(
                                student['name']?[0].toUpperCase() ?? 'S',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              student['name'] ?? 'Untitled',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(student['email'] ?? 'No email'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                student['studentId'] ?? 'ID: N/A',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3A4F9B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
