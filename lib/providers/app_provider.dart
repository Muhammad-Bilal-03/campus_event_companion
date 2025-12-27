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
  List<Event> get events => _events;

  // UPDATED: Filter Logic
  List<Event> get filteredEvents {
    return _events.where((event) {
      // 1. Search Filter
      final matchesSearch =
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Category / Status Filter
      bool matchesCategory = false;
      if (_selectedCategory == "All") {
        matchesCategory = true;
      } else if (_selectedCategory == "Interested") {
        // Filter by Status: Interested
        matchesCategory = event.participationStatus == "Interested";
      } else if (_selectedCategory == "Going") {
        // Filter by Status: Going
        matchesCategory = event.participationStatus == "Going";
      } else {
        // Filter by Actual Category (e.g., "Sports")
        matchesCategory = event.category == _selectedCategory;
      }

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // UPDATED: Categories List includes Statuses
  List<String> get categories {
    // We explicitly add "Interested" and "Going" after "All"
    final allCategories = _events.map((e) => e.category).toSet().toList();
    allCategories.sort(); // Optional: Sort categories alphabetically

    return ["All", "Interested", "Going", ...allCategories];
  }

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(EventAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserAdapter());

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

  Future<bool> updateParticipationStatus(String id, String newStatus) async {
    final event = _eventBox!.get(id);
    if (event != null) {
      final oldStatus = event.participationStatus;

      if (newStatus == 'Going' && oldStatus != 'Going') {
        if (event.totalSeats != null && event.seatsTaken >= event.totalSeats!) {
          return false;
        }
        event.seatsTaken++;
      } else if (newStatus != 'Going' && oldStatus == 'Going') {
        if (event.seatsTaken > 0) event.seatsTaken--;
      }

      event.participationStatus = newStatus;
      await event.save();

      if (newStatus == 'Interested' || newStatus == 'Going') {
        NotificationService.showNotification(
          id: event.id.hashCode,
          title: 'Status Updated',
          body: 'You are marked as "$newStatus" for ${event.title}',
        );
      }
      _loadEvents();
      return true;
    }
    return false;
  }
}
