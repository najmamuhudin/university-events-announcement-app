import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class EventService {
  Future<List<dynamic>> getEvents() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/events'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<dynamic> createEvent(Map<String, dynamic> eventData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/events'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to create event',
      );
    }
  }

  Future<String?> uploadImage(List<int> bytes, String filename) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/events/upload'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    // Add content type for web compatibility
    final mimeType =
        filename.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: filename,
        contentType: http.MediaType.parse(mimeType),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['imageUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> registerForEvent(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/events/register/$eventId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode != 200) {
      String errorMessage = 'Failed to register for event';
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        try {
          errorMessage = jsonDecode(response.body)['message'] ?? errorMessage;
        } catch (_) {}
      } else {
        errorMessage = 'Server error (${response.statusCode})';
      }
      throw Exception(errorMessage);
    }
  }

  Future<dynamic> updateEvent(String id, Map<String, dynamic> eventData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/events/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to update event',
      );
    }
  }

  Future<void> deleteEvent(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/events/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to delete event',
      );
    }
  }
}
