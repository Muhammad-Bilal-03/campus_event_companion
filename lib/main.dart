import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/theme_provider.dart'; // New import
import 'utils/app_theme.dart'; // New import
import 'utils/constants.dart'; // New import
import 'screens/welcome_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  final appProvider = AppProvider();
  await appProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CampusCompanionApp(),
    ),
  );
}

class CampusCompanionApp extends StatelessWidget {
  const CampusCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer listens to ThemeProvider changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
