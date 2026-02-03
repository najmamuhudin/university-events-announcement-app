import 'package:flutter/material.dart';
import '../services/admin_service.dart';

/// Provider for managing admin-related data such as announcements, inquiries, and stats.
class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<dynamic> _announcements = [];
  List<dynamic> _inquiries = [];
  List<dynamic> _students = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _error;

  List<dynamic> get announcements => _announcements;
  List<dynamic> get inquiries => _inquiries;
  List<dynamic> get students => _students;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _stats = await _adminService.getDashboardStats();
    } catch (e) {
      _error = e.toString();
      print('Error fetching stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _announcements = await _adminService.getAnnouncements();
    } catch (e) {
      _error = e.toString();
      print('Error fetching announcements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postAnnouncement(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _adminService.postAnnouncement(data);
      await fetchAnnouncements();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInquiries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _inquiries = await _adminService.getInquiries();
    } catch (e) {
      _error = e.toString();
      print('Error fetching inquiries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendInquiry(String subject, String message) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _adminService.postInquiry({'subject': subject, 'message': message});
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resolveInquiry(String id) async {
    _error = null;
    try {
      await _adminService.resolveInquiry(id);
      await fetchInquiries();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateAnnouncement(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _adminService.updateAnnouncement(id, data);
      await fetchAnnouncements();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    _error = null;
    try {
      await _adminService.deleteAnnouncement(id);
      _announcements.removeWhere((a) => a['_id'] == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> deleteInquiry(String id) async {
    _error = null;
    try {
      await _adminService.deleteInquiry(id);
      _inquiries.removeWhere((i) => i['_id'] == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> fetchStudents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _students = await _adminService.getStudents();
    } catch (e) {
      _error = e.toString();
      print('Error fetching students: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
