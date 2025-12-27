import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/event_card.dart'; // Import the new widget
import 'welcome_screen.dart';
import 'calendar_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access providers
    // We use listen: false for actions, and Consumer for rebuilding UI
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: _buildAppBar(context, themeProvider, isDark),
      body: Column(
        children: [
          // Extracted Header Area
          _buildHeader(context, isDark),

          // Extracted List Area
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                // Notice: logic is now in the Provider getter 'filteredEvents'
                // This keeps the build method CLEAN.
                final events = provider.filteredEvents;

                if (events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: events[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    return AppBar(
      elevation: 0,
      flexibleSpace: isDark
          ? null
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppConstants.gradientColors),
              ),
            ),
      title: Text(
        'Student Dashboard',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: Colors.white,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_month, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalendarScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white),
          onPressed: () {
            Provider.of<AppProvider>(context, listen: false).logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(colors: [Colors.grey[900]!, Colors.grey[800]!])
            : const LinearGradient(colors: AppConstants.gradientColors),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Campus Feed',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              return TextField(
                onChanged: (value) => provider.setSearchQuery(value),
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: provider.categories.map((category) {
                    final isSelected = provider.selectedCategory == category;
                    // Simplify logic for chip colors
                    final chipBg = isSelected
                        ? (isDark ? AppColors.primary : Colors.white)
                        : (isDark
                              ? Colors.grey[800]!
                              : Colors.white.withValues(alpha: 0.2));
                    final chipText = isSelected
                        ? (isDark ? Colors.white : AppColors.primary)
                        : Colors.white;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => provider.setCategory(category),
                        selectedColor: chipBg,
                        backgroundColor: chipBg,
                        labelStyle: GoogleFonts.poppins(
                          color: chipText,
                          fontWeight: FontWeight.w600,
                        ),
                        checkmarkColor: chipText,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
