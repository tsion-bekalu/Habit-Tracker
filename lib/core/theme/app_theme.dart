import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF864CD2);
  static const Color backgroundColor = Color(0xFFF8F9FE);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        surface: Colors.white,
        background: backgroundColor,
      ),
      fontFamily: 'Poppins', // Matches your preference
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}