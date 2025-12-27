import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../utils/constants.dart';
import '../screens/event_details_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final Widget? trailing; // New: Allow Admin to pass a delete button

  const EventCard({super.key, required this.event, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    // Logic: Status Icon for Students
    Widget statusIndicator = const SizedBox.shrink();
    if (trailing == null) {
      // Only show status if not in Admin mode (trailing is null)
      IconData icon = Icons.circle_outlined;
      Color color = Colors.grey;
      if (event.participationStatus == 'Going') {
        icon = Icons.check_circle;
        color = Colors.green;
      } else if (event.participationStatus == 'Interested') {
        icon = Icons.star;
        color = Colors.amber;
      }
      statusIndicator = Icon(icon, color: color, size: 28);
    }

    // Seat Logic for UI
    String? seatInfo;
    Color seatColor = Colors.grey;
    if (event.totalSeats != null) {
      int remaining = event.totalSeats! - event.seatsTaken;
      if (remaining <= 0) {
        seatInfo = "FULL";
        seatColor = Colors.red;
      } else {
        seatInfo = "$remaining seats";
        seatColor = AppColors.primary;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap:
            onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailsScreen(event: event),
                ),
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date Box - Uses Constants
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppConstants.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd').format(event.date),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(event.date),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Event Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.location,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event.category.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (seatInfo != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            seatInfo,
                            style: GoogleFonts.poppins(
                              color: seatColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Polymorphic Area: Shows Status (Student) or Delete Button (Admin)
              if (trailing != null) trailing! else statusIndicator,
            ],
          ),
        ),
      ),
    );
  }
}
