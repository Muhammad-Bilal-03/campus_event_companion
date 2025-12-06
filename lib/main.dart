import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => appProvider)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Event Companion',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
