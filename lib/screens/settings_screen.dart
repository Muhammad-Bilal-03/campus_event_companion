import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF2E3192),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Enable dark theme for the app',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: const Color(0xFF2E3192),
              ),
              value: isDark,
              onChanged: (value) => provider.toggleTheme(),
              activeTrackColor: const Color(
                0xFF2E3192,
              ), // Fixed deprecated param
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Campus Event Companion v1.1.0',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
