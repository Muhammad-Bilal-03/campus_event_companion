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
    // Re-access event from provider to get live updates on seats
    final provider = Provider.of<AppProvider>(context);
    final liveEvent = provider.events.firstWhere(
      (e) => e.id == event.id,
      orElse: () => event,
    );

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          liveEvent.category.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF2E3192),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      // New: Seats Indicator
                      if (liveEvent.totalSeats != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (liveEvent.seatsTaken >= liveEvent.totalSeats!)
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  (liveEvent.seatsTaken >=
                                      liveEvent.totalSeats!)
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          child: Text(
                            (liveEvent.seatsTaken >= liveEvent.totalSeats!)
                                ? "FULL"
                                : "${liveEvent.totalSeats! - liveEvent.seatsTaken} seats left",
                            style: GoogleFonts.poppins(
                              color:
                                  (liveEvent.seatsTaken >=
                                      liveEvent.totalSeats!)
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    liveEvent.title,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
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
                              liveEvent,
                              'None',
                              Icons.cancel_outlined,
                              isDark,
                            ),
                            _buildStatusOption(
                              context,
                              provider,
                              liveEvent,
                              'Interested',
                              Icons.star_outline,
                              isDark,
                            ),
                            _buildStatusOption(
                              context,
                              provider,
                              liveEvent,
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
                    DateFormat('EEEE, MMMM d, yyyy').format(liveEvent.date),
                    isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.location_on,
                    'Location',
                    liveEvent.location,
                    isDark,
                  ),

                  if (liveEvent.linkUrl != null &&
                      liveEvent.linkUrl!.isNotEmpty) ...[
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
                                  WebViewScreen(url: liveEvent.linkUrl!),
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
                    liveEvent.description,
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

    // Logic to disable "Going" if full and not already going
    bool isFull = false;
    if (value == 'Going' &&
        event.participationStatus != 'Going' &&
        event.totalSeats != null) {
      if (event.seatsTaken >= event.totalSeats!) {
        isFull = true;
      }
    }

    return InkWell(
      onTap: isFull
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sorry, this event is full!')),
              );
            }
          : () async {
              bool success = await provider.updateParticipationStatus(
                event.id,
                value,
              );
              if (!success && value == 'Going') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sorry, this event is full!')),
                );
              }
            },
      child: Opacity(
        opacity: isFull ? 0.4 : 1.0,
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
            if (isFull)
              Text(
                '(Full)',
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 10),
              ),
          ],
        ),
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
