import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3A4F9B); // New brand color
  static const Color accentColor = Color(0xFF5C70B8);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2D3142);
  static const Color subtitleColor = Color(0xFF9E9E9E);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);

  static TextTheme textTheme = GoogleFonts.poppinsTextTheme().copyWith(
    displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    bodyLarge: TextStyle(color: textColor),
    bodyMedium: TextStyle(color: textColor),
    titleMedium: TextStyle(color: subtitleColor),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: accentColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: textTheme.titleLarge!.copyWith(color: textColor),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
