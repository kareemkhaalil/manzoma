import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF2563EB),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    primaryColor: const Color(0xFF1A202C),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey.shade800,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white54),
      labelSmall: TextStyle(color: Colors.white54),
    ),
  );
}
