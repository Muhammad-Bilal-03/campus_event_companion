import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/event_card.dart'; // Reuse here too!

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final allEvents = provider.events;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter events for selected day
    final selectedEvents = _selectedDay == null
        ? []
        : allEvents.where((e) => isSameDay(e.date, _selectedDay)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Calendar',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? AppColors.cardDark : AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.only(bottom: 16),
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              onFormatChanged: (format) =>
                  setState(() => _calendarFormat = format),
              eventLoader: (day) =>
                  allEvents.where((e) => isSameDay(e.date, day)).toList(),

              // Styles using AppColors
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                weekendTextStyle: GoogleFonts.poppins(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: isDark ? Colors.white : Colors.black54,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay == null
                ? Center(
                    child: Text(
                      'Select a date',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return EventCard(event: selectedEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
