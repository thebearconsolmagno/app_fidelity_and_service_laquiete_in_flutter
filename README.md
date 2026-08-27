# La Quiete Mobile

Cross-platform Flutter application for **La Quiete — Hotel, Restaurant and Bar**. It gives customers a mobile experience for browsing the menu, tracking loyalty rewards, and requesting reservations.

## Features

- Registration, login, and password recovery
- Menu with categories, images, prices, and allergen information
- Loyalty points and transaction history
- Reservation requests and tracking
- Backend-provided branding and visual theme
- On-device session persistence
- Android, iOS, Web, Windows, macOS, and Linux support
- Italian customer interface

## Technology

- Flutter and Dart
- Provider for state management
- HTTP for REST API integration
- Shared Preferences for local persistence
- Google Fonts
- Intl
- QR Flutter

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- A compatible Dart SDK
- A configured emulator, physical device, or browser
- A compatible running Flask backend

### Installation

```bash
git clone <URL_DO_REPOSITORIO>
cd la_quiete_flutter
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

On an Android emulator, the host computer is usually available at `http://10.0.2.2:5000`. On a physical device, use the local IP address of the machine running the backend.

## Configuration

Configuration is supplied at compile time:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.exemplo.com \
  --dart-define=SYSTEM_USER=username \
  --dart-define=SYSTEM_PASS=password
```

`SYSTEM_USER` and `SYSTEM_PASS` are optional and should only be used when a legacy backend requires Basic authentication. Client applications can be inspected, so these values must not be treated as secrets. For production, prefer individual authentication with short-lived tokens and server-side validation.

## Useful Commands

```bash
flutter analyze          # Run static analysis
flutter test             # Run automated tests
flutter build apk        # Build an Android APK
flutter build appbundle  # Build an Android App Bundle
flutter build web        # Build the web application
```

## Project Structure

```text
├── assets/           # Icons and visual assets
├── lib/
│   ├── config/       # Environment configuration
│   ├── models/       # Data models
│   ├── pages/        # Customer-facing screens
│   ├── providers/    # Application state and session
│   ├── services/     # API integration
│   └── main.dart     # Application entry point
├── test/             # Automated tests
├── android/          # Android project
├── ios/              # iOS project
└── web/              # Web project
```

## Backend Integration

This repository contains only the client application. Its features depend on a REST API that provides authentication, public theme, menu, loyalty, and reservation endpoints. Configure HTTPS, CORS, and server-side authentication before publishing.

## License

Portfolio project. The source code is available for review and demonstration; no commercial usage rights are granted without the author's permission.
