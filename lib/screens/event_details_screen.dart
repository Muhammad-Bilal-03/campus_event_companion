import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/app_provider.dart';
import 'webview_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Event Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: isDark
            ? null
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
                  ),
                ),
              ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        colors: [Colors.grey[900]!, Colors.grey[800]!],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
                      ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.event,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3192).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : const Color(0xFF2E3192),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      // Dynamic color: White in dark mode, Blue in light mode
                      color: isDark ? Colors.white : const Color(0xFF2E3192),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendance Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Attendance',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatusOption(
                              context,
                              provider,
                              event,
                              'None',
                              Icons.cancel_outlined,
                              isDark,
                            ),
                            _buildStatusOption(
                              context,
                              provider,
                              event,
                              'Interested',
                              Icons.star_outline,
                              isDark,
                            ),
                            _buildStatusOption(
                              context,
                              provider,
                              event,
                              'Going',
                              Icons.check_circle_outline,
                              isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat('EEEE, MMMM d, yyyy').format(event.date),
                    isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.location_on,
                    'Location',
                    event.location,
                    isDark,
                  ),

                  if (event.linkUrl != null && event.linkUrl!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WebViewScreen(url: event.linkUrl!),
                            ),
                          );
                        },
                        icon: const Icon(Icons.language),
                        label: Text(
                          'Visit Official Page',
                          style: GoogleFonts.poppins(),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E3192),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                  Text(
                    'About this event',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF2E3192),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    AppProvider provider,
    Event event,
    String value,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = event.participationStatus == value;
    final color = isSelected
        ? (isDark ? Colors.white : const Color(0xFF2E3192))
        : Colors.grey;

    return InkWell(
      onTap: () => provider.updateParticipationStatus(event.id, value),
      child: Column(
        children: [
          Icon(
            isSelected ? _getFilledIcon(icon) : icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilledIcon(IconData icon) {
    if (icon == Icons.star_outline) return Icons.star;
    if (icon == Icons.check_circle_outline) return Icons.check_circle;
    return Icons.cancel;
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF2E3192)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
