import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0E3A5B);

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: primaryBlue,
    primaryColor: primaryBlue,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),

      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),

      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),

      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      bodySmall: TextStyle(
        color: Colors.white60,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent, // ✅ fixed
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
