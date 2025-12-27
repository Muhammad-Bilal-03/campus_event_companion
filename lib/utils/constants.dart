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
  static const String appName = 'Campus Event Companion';
  static const List<Color> gradientColors = [
    AppColors.primary,
    AppColors.accent,
  ];

  // --- CITY PLANNER COORDINATES (Symmetrical & Aligned) ---
  static const Map<String, Offset> campusLocations = {
    // 1. THE NORTH AXIS (Focal Point)
    'Auditorium': Offset(0.5, 0.15), // Top Center
    // 2. THE ACADEMIC QUAD (Upper Flanks)
    'Main Library': Offset(0.20, 0.25), // Top Left
    'CS Department': Offset(0.80, 0.25), // Top Right
    // 3. THE CENTRAL HUB (Middle)
    'Student Center': Offset(0.5, 0.45), // Dead Center (The Heart)
    'Admin Block': Offset(0.20, 0.45), // Mid Left (Aligned with Library X)
    'Engineering Block': Offset(0.80, 0.45), // Mid Right (Aligned with CS X)
    // 4. THE SERVICE LOOP (Lower Flanks)
    'Cafeteria': Offset(0.20, 0.65),
    'Mosque': Offset(0.80, 0.65),

    // 5. THE SOUTH ENTRANCE (Bottom)
    'Sports Ground': Offset(0.5, 0.70), // Center Green
    'Gymnasium': Offset(0.80, 0.85), // Bottom Right
    'Parking Lot': Offset(0.20, 0.85), // Bottom Left
    'Main Gate': Offset(0.5, 0.95), // Entry Point
  };
}
