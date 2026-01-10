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

## 📸 Screenshots

| **Student Dashboard** | **Interactive Map** |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/7c9bceb3-f955-4d55-a4b0-cd6c3130fa17" width="300" /> | <img src="https://github.com/user-attachments/assets/751b33f4-5c43-4d46-952f-725166912122" width="300" /> |
| **Event Details** | **Admin Console** |
| <img src="https://github.com/user-attachments/assets/80f5f9d2-a144-4a1a-999d-8b70aa95ca2b" width="300" /> | <img src="https://github.com/user-attachments/assets/3844ae6d-978b-467a-bafa-20c15c0c3011" width="300" /> |

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

## 🏗️ Getting Started

Follow these steps to set up the project locally.

### Prerequisites
* Flutter SDK installed
* VS Code or Android Studio

### Installation

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/Muhammad-Bilal-03/campus_event_companion.git](https://github.com/Muhammad-Bilal-03/campus_event_companion.git)
    ```

2.  **Navigate to the project directory**
    ```bash
    cd campus_event_companion
    ```

3.  **Install dependencies**
    ```bash
    flutter pub get
    ```

4.  **Run the App**
    ```bash
    flutter run
    ```

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

```

---

## 👤 Author

**Muhammad Bilal**

* **Role:** Lead Developer
* **LinkedIn:** [linkedin.com/in/muhammad-bilal-bsse](https://www.linkedin.com/in/muhammad-bilal-bsse/)
* **GitHub:** [github.com/Muhammad-Bilal-03](https://www.google.com/search?q=https://github.com/Muhammad-Bilal-03)

*Developed as a Semester Project for BS Software Engineering at COMSATS University.



