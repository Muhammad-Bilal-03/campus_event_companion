import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2E3192);
  static const Color accent = Color(0xFF1BFFFF);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);
}

class AppConstants {
  // UPDATED: New App Name
  static const String appName = 'Campus Pulse';

  static const List<Color> gradientColors = [
    AppColors.primary,
    AppColors.accent,
  ];

  static const Map<String, Offset> campusLocations = {
    'Main Gate': Offset(0.5, 0.95),
    'Admin Block': Offset(0.5, 0.82),
    'Student Center': Offset(0.5, 0.55),
    'Auditorium': Offset(0.5, 0.35),
    'Mosque': Offset(0.15, 0.12),
    'Main Library': Offset(0.20, 0.30),
    'CS Department': Offset(0.80, 0.30),
    'Cafeteria': Offset(0.20, 0.55),
    'Engineering Block': Offset(0.80, 0.55),
    'Parking Lot': Offset(0.15, 0.85),
    'Gymnasium': Offset(0.85, 0.85),
    'Sports Ground': Offset(0.85, 0.72),
  };
}
