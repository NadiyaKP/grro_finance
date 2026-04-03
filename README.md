# Grro Finance

A modern, high-performance Flutter financial management application with a focus on real-time authentication and intuitive withdrawal request management.

## 🚀 Key Features

- **Advanced Authentication**: Seamless Login and Sign Up powered by Firebase.
- **Smart Session Persistence**: Persistent user sessions using SharedPreferences (auto-login after app restart).
- **Interactive Dashboard**: A 4-card grid for real-time tracking of Lead Fees, Commission, and Revenue.
- **Withdrawal Management**:
  - Unified list of withdrawal requests with quick Accept/Reject actions.
  - Detailed "Marketer" screen with user statistics and transaction history.
  - Smooth horizontal PageView for pending requests with dynamic dot indicators.
- **Premium UI/UX**:
  - Clean, responsive design matching Figma specifications.
  - Navigation Drawer for easy access to features and Logout.
  - SnackBar notifications for human-readable error handling.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/) (MVVM Architecture)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Backend**: [Firebase Authentication](https://firebase.google.com/products/auth)
- **Local Persistence**: [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Design Pattern**: MVVM (Model-View-ViewModel)

## 📁 Project Structure

```text
lib/
├── core/
│   ├── theme/          # App design tokens and themes
│   ├── router/         # GoRouter configuration
│   └── services/       # Global services (Auth, Storage)
├── features/
│   ├── splash/         # Intro and session checking logic
│   ├── auth/           # Login and Registration modules
│   ├── home/           # Dashboard and main landing
│   └── withdrawal/     # Management and History modules
└── main.dart           # App entry point
```

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK (Latest Stable)
- Android Studio / VS Code
- A Firebase project with Android app configured

### Steps
1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Firebase Configuration**:
   - Place your `google-services.json` in `android/app/`.
   - Ensure Firebase Auth is enabled in your console.
4. **Run the app**:
   ```bash
   flutter run
   ```

## 📐 Architecture

This project strictly adheres to the **MVVM** pattern:
- **Models**: Plain data objects and Firebase converters.
- **Views**: Flutter widgets that consume data from Providers.
- **ViewModels**: StateNotifiers and FutureProviders that handle business logic and state updates.

---

