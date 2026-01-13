# 📱 Campus Event Companion

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-NoSQL-%23ff6f00.svg?style=for-the-badge)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)

**A Comprehensive Flutter Application for University Event Management.**

Campus Event Companion is a feature-rich mobile application designed to bridge the gap between student organizers and attendees. Built with **Flutter**, it features role-based access control, a custom interactive campus map, and offline-first capabilities using **Hive** to ensure students stay connected even without internet access.

---

## 📸 App Screenshots

| Student Dashboard | Interactive Map |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/7c9bceb3-f955-4d55-a4b0-cd6c3130fa17" width="250" alt="Student Dashboard"> | <img src="https://github.com/user-attachments/assets/751b33f4-5c43-4d46-952f-725166912122" width="250" alt="Interactive Map"> |

| Event Details | Admin Console |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/80f5f9d2-a144-4a1a-999d-8b70aa95ca2b" width="250" alt="Event Details"> | <img src="https://github.com/user-attachments/assets/3844ae6d-978b-467a-bafa-20c15c0c3011" width="250" alt="Admin Console"> |

---

## ✨ Key Features

### 🎓 For Students
* **🗺️ Interactive Campus Map:** A custom-painted, zoomable map (built using `CustomPainter`) to easily locate event venues.
* **🔍 Event Discovery:** Browse events with advanced filters (Category, Search, Status).
* **📅 Smart Calendar:** Built-in calendar view to track upcoming schedules using `table_calendar`.
* **👍 Engagement:** Mark attendance as "Interested" or "Going" with real-time seat limit validation.
* **💾 Offline Access:** All data is cached locally using **Hive**, ensuring the app works flawlessly offline.

### 🛡️ For Admins
* **💻 Dashboard Console:** A dedicated admin panel to manage the entire event lifecycle.
* **📝 CRUD Operations:** Create, Update, and Delete events with ease.
* **📊 Analytics:** Track seat occupancy and user engagement statistics.
* **🔐 Secure Auth:** Separate secure login portal for administrators.

---

## 🛠️ Tech Stack & Architecture

This project follows a **Modular Architecture** with **Provider** for state management to ensure scalability.

### Core Technologies
* **Framework:** Flutter (Dart)
* **State Management:** `Provider`
* **Local Database:** `Hive` (NoSQL for offline persistence)
* **Graphics:** `CustomPainter` (For the campus map)
* **Notifications:** `flutter_local_notifications`

### Architecture Overview
* **`lib/models`**: Hive TypeAdapters and Data classes.
* **`lib/services`**: Background tasks and notification logic.
* **`lib/providers`**: Application state and Theme switching logic.
* **`lib/widgets`**: Reusable components like `EventCard` and the `MapPainter`.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (Latest Stable)
* VS Code or Android Studio

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Muhammad-Bilal-03/campus_event_companion.git](https://github.com/Muhammad-Bilal-03/campus_event_companion.git)
    cd campus_event_companion
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the App:**
    ```bash
    flutter run
    ```

> **Note:** The app uses Hive for local storage. No complex backend setup is required for the initial run as it uses a local database approach.

---

## 📂 Folder Structure

```text
lib/
├── models/         # Hive Data Models (Event, User)
├── providers/      # State Logic (AppProvider, ThemeProvider)
├── screens/        # UI Screens (Student/Admin Views, Maps, Calendar)
├── services/       # Notification Logic & Background Tasks
├── utils/          # Constants, Themes, and App Colors
├── widgets/        # Reusable Components (EventCard, MapPainter)
└── main.dart       # App Entry Point

```

---

## 📦 Dependencies

Major packages used in this project:

| Package | Purpose |
| --- | --- |
| `provider` | State Management |
| `hive` & `hive_flutter` | Local NoSQL Database |
| `flutter_local_notifications` | Push Notifications |
| `table_calendar` | Calendar Visualization |
| `webview_flutter` | In-app Browser |
| `path_provider` | Directory Path Management |

---

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any features or bug fixes.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'Add some NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

---

## 👤 Author

**Muhammad Bilal**

* **Role:** Lead Developer
* **LinkedIn:** [linkedin.com/in/muhammad-bilal-bsse](https://www.linkedin.com/in/muhammad-bilal-bsse/)
* **GitHub:** [github.com/Muhammad-Bilal-03](https://www.google.com/search?q=https://github.com/Muhammad-Bilal-03)

*Developed as a Semester Project for BS Software Engineering at COMSATS University.*
