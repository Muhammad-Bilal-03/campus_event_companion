import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../widgets/campus_map_painter.dart'; // Import the painter

class CampusMapScreen extends StatelessWidget {
  final String? highlightLocation;

  const CampusMapScreen({super.key, this.highlightLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Campus Map',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        // Make the canvas large enough to scroll around
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height:
              MediaQuery.of(context).size.height * 1.5, // Taller than screen
          child: CustomPaint(
            painter: CampusMapPainter(highlightLocation: highlightLocation),
            // No child needed, the painter draws everything
          ),
        ),
      ),
    );
  }
}
