import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  Box<Event>? _eventBox;
  Box<User>? _userBox;
  User? _currentUser;

  // --- Filter State ---
  String _searchQuery = "";
  String _selectedCategory = "All";

  List<Event> _events = [];

  // --- Getters ---
  User? get currentUser => _currentUser;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  String get selectedCategory => _selectedCategory;

  // FIX 1: Expose the raw list of events for Admin & Calendar
  List<Event> get events => _events;

  // --- OPTIMIZED FILTERING LOGIC ---
  List<Event> get filteredEvents {
    if (_searchQuery.isEmpty && _selectedCategory == "All") {
      return _events;
    }

    return _events.where((event) {
      final matchesSearch =
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "All" || event.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get categories {
    // FIX 2: Removed unnecessary .toList() inside spread
    return ["All", ..._events.map((e) => e.category).toSet()];
  }

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

  // --- Search Actions ---
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // --- Auth & Event Management ---
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
    if (_userBox!.values.any((u) => u.username == username)) return false;
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
    _searchQuery = "";
    _selectedCategory = "All";
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

  Future<void> updateParticipationStatus(String id, String status) async {
    final event = _eventBox!.get(id);
    if (event != null) {
      event.participationStatus = status;
      await event.save();

      if (status == 'Interested' || status == 'Going') {
        NotificationService.showNotification(
          id: event.id.hashCode,
          title: 'Status Updated',
          body: 'You are marked as "$status" for ${event.title}',
        );
      }
      _loadEvents();
    }
  }
}
