import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}

class AppRadius {
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 10.0;
  static const double xl = 14.0;
  static const double xxl = 16.0;
  static const double full = 20.0;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get xxlAll => BorderRadius.circular(xxl);
}

class AppFont {
  static const double caption = 11.0;
  static const double bodySmall = 12.0;
  static const double body = 13.0;
  static const double bodyLarge = 14.0;
  static const double subtitle = 15.0;
  static const double title = 16.0;
  static const double appBarTitle = 18.0;
}

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF22d3ee),
      brightness: Brightness.light,
      primary: const Color(0xFF22d3ee),
      surface: const Color(0xFFF3F5F9),
    ),
    scaffoldBackgroundColor: const Color(0xFFF3F5F9),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF22d3ee),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    iconTheme: IconThemeData(color: Colors.grey.shade700),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF22d3ee),
      brightness: Brightness.dark,
      primary: const Color(0xFF22d3ee),
      surface: const Color(0xFF1A1A2E),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F1A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: const Color(0xFF1E1E30),
    dividerColor: Colors.grey.shade800,
    iconTheme: IconThemeData(color: Colors.grey.shade400),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Colors.white54),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );
}
