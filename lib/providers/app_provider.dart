import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  Box<Event>? _eventBox;
  Box<User>? _userBox;
  User? _currentUser;

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

  Future<void> addEvent(Event event) async {
    await _eventBox!.put(event.id, event);
    _loadEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _eventBox!.delete(id);
    _loadEvents();
  }

  Future<void> toggleReminder(String id) async {
    final event = _eventBox!.get(id);
    if (event != null) {
      event.isFavorite = !event.isFavorite;
      await event.save();

      if (event.isFavorite) {
        // Trigger Immediate Notification
        NotificationService.showNotification(
          id: event.id.hashCode,
          title: 'Reminder Set!',
          body: 'You will be reminded about "${event.title}"',
        );
        if (event.date.isAfter(DateTime.now())) {
          NotificationService.scheduleNotification(
            id: event.id.hashCode + 1,
            title: 'Upcoming Event!',
            body: '${event.title} is starting soon at ${event.location}.',
            scheduledDate: event.date.subtract(const Duration(hours: 1)),
          );
        }
      }

      _loadEvents();
    }
  }
}
