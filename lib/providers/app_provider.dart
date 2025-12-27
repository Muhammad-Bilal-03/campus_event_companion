import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  Box<Event>? _eventBox;
  Box<User>? _userBox;
  User? _currentUser;

  // Theme State
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  List<Event> _events = [];
  List<Event> get events => _events;
  User? get currentUser => _currentUser;

  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EventAdapter());
    Hive.registerAdapter(UserAdapter());

    _eventBox = await Hive.openBox<Event>('events');
    _userBox = await Hive.openBox<User>('users');

    // Load Theme Preference
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    if (_userBox!.isEmpty) {
      _userBox!.put(
        'admin',
        User(username: 'admin', password: '123', isAdmin: true),
      );
      _userBox!.put(
        'student',
        User(username: 'student', password: '123', isAdmin: false),
      );
    }

    _loadEvents();
  }

  void _loadEvents() {
    _events = _eventBox!.values.toList();
    _events.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  // --- Theme Management ---
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      await prefs.setBool('isDark', false);
    } else {
      _themeMode = ThemeMode.dark;
      await prefs.setBool('isDark', true);
    }
    notifyListeners();
  }

  // --- Auth Management ---
  bool login(String username, String password) {
    try {
      final user = _userBox!.values.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool signUp(String username, String password, bool isAdmin) {
    if (_userBox!.values.any((u) => u.username == username)) {
      return false;
    }
    final newUser = User(
      username: username,
      password: password,
      isAdmin: isAdmin,
    );
    _userBox!.add(newUser);
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // --- Event Management ---
  Future<void> addEvent(Event event) async {
    await _eventBox!.put(event.id, event);
    _loadEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _eventBox!.delete(id);
    _loadEvents();
  }

  // Updated Attendance Logic
  Future<void> updateParticipationStatus(String id, String status) async {
    final event = _eventBox!.get(id);
    if (event != null) {
      event.participationStatus = status;
      await event.save();

      // Schedule notification if user is Interested or Going
      if (status == 'Interested' || status == 'Going') {
        // Immediate Feedback
        NotificationService.showNotification(
          id: event.id.hashCode,
          title: 'Status Updated',
          body: 'You are marked as "$status" for ${event.title}',
        );

        // Schedule Alarm
        if (event.date.isAfter(DateTime.now())) {
          NotificationService.scheduleNotification(
            id: event.id.hashCode + 1,
            title: 'Event Reminder',
            body: '${event.title} is starting soon! Status: $status',
            scheduledDate: event.date.subtract(const Duration(hours: 1)),
          );
        }
      }

      _loadEvents();
    }
  }
}
