import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppConstants {
  // Base URL for Android Emulator (10.0.2.2 points to localhost of host machine)
  // Use http://localhost:5000 if running on Web or Windows
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }

  static String get baseImageUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    } else {
      return 'http://localhost:5000';
    }
  }

  // Colors
  static const Color primaryColor = Color(0xFF3A4F9B); // New brand color
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryColor = Color(0xFF6C757D);
}
