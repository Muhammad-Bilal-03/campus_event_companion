# 📱 Campus Event Companion

### A Comprehensive Flutter Application for University Event Management

**Campus Event Companion** is a feature-rich mobile application designed to bridge the gap between student organizers and attendees. Built with **Flutter**, it features role-based access control, an interactive campus map, and offline-first capabilities using **Hive**.

---

## 🚀 Key Features

### 🎓 For Students
* **Interactive Campus Map:** A custom-painted, zoomable map of the campus (built using `CustomPainter`) to easily locate event venues.
* **Event Discovery:** Browse events with advanced filters (Category, Search, Status).
* **Smart Calendar:** A built-in calendar view to track upcoming schedules.
* **Engagement:** Mark attendance as "Interested" or "Going" (with seat limit validation).
* **Offline Access:** All data is cached locally using **Hive**, ensuring the app works without internet.

### 🛡️ For Admins
* **Dashboard Console:** A dedicated admin panel to manage the event lifecycle.
* **CRUD Operations:** Create, Update, and Delete events with ease.
* **Analytics:** Track seat occupancy and user engagement in real-time.
* **Secure Auth:** Separate secure login portal for administrators.

---

## 🛠️ Tech Stack & Architecture

This project follows a **Modular Architecture** with **Provider** for state management.

| Category | Technology | Usage |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart) | UI & Logic |
| **State Management** | Provider | App-wide state & Theme switching |
| **Local Database** | Hive (NoSQL) | Persistence for Events & Users |
| **UI Components** | CustomPainter | High-performance interactive Map |
| **Notifications** | Flutter Local Notifications | Event reminders & updates |
| **Calendar** | Table Calendar | Schedule visualization |
| **Web Integration** | WebView Flutter | In-app browser for external links |

---

## 📂 Project Structure

```text
lib/
├── models/         # Hive Data Models (Event, User)
├── providers/      # State Logic (AppProvider, ThemeProvider)
├── screens/        # UI Screens (Student/Admin Views, Maps, Calendar)
├── services/       # Notification Logic & Background Tasks
├── utils/          # Constants, Themes, and App Colors
├── widgets/        # Reusable Components (EventCard, MapPainter)
└── main.dart       # App Entry Point
