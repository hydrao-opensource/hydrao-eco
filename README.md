# Hydrao Eco

An offline-first Flutter mobile app for Hydrao smart showerheads. Connect to your device over Bluetooth, track shower history, and monitor water and energy savings — all stored locally on your phone, no cloud account required.

## Features

- **BLE connection** — Scan, connect, and sync data from Hydrao showerheads (Aloe, Cereus, Yucca, First)
- **Live session** — Real-time flow, volume, and temperature readout during a shower
- **Shower history** — Full history synced from the device, stored in a local SQLite database
- **Water & energy savings** — Stats and cost calculations with per-country unit and price settings
- **Soaping timer** — Pause/resume flow tracking during lathering
- **Color thresholds** — Configure the LED color steps on the showerhead (volume targets)
- **Learning period** — Automatic baseline calibration cycle for personalized thresholds
- **Backup & restore** — Export/import your data as a JSON file
- **Offline-first** — Works without an internet connection; no user account needed
- **Multi-language** — English and French (auto-detected from device locale)
- **Dark/light theme** — Follows the system theme

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.8.1
- Dart SDK ≥ 3.8.1
- For iOS: Xcode + CocoaPods
- For Android: Android Studio + SDK (min API 21)
- A Firebase project with Crashlytics enabled (see [Firebase setup](#3-firebase-setup))

Check your environment:

```bash
flutter doctor
```

## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/hydrao-opensource/hydrao-eco.git
cd hydrao-eco
```

### 2. Configure environment variables

Copy the sample environment file and fill in your values:

```bash
cp env.sample.json env.json
```

Edit `env.json`:

```json
{ "API_KEY": "your-api-key" }
```

> `env.json` is excluded from version control. Never commit it.

### 3. Firebase setup

This project uses Firebase Crashlytics for crash reporting.

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an **Android** app (package name: `com.hydrao.hydrao_flutter_offline`) and download `google-services.json` → place it in `android/app/`
3. Add an **iOS** app (bundle ID from `ios/Runner/Info.plist`) and download `GoogleService-Info.plist` → place it in `ios/Runner/`
4. Enable **Crashlytics** in the Firebase console

> Sample config files (`google-services.json`, `GoogleService-Info.plist`) are included in the repository for build compatibility. Replace them with your own before publishing.

### 4. Install dependencies

```bash
flutter pub get
```

### 5. Run the app

```bash
flutter run --debug --dart-define-from-file=env.json
```

Force English locale:

```bash
flutter run --dart-define=FORCE_EN=true --dart-define-from-file=env.json
```

## Build

| Target         | Command                                                    | Output                                             |
| -------------- | ---------------------------------------------------------- | -------------------------------------------------- |
| iOS            | `flutter build ios --dart-define-from-file=env.json`       | `build/ios/iphoneos/Runner.app`                    |
| Android APK    | `flutter build apk --dart-define-from-file=env.json`       | `build/app/outputs/flutter-apk/app-release.apk`    |
| Android Bundle | `flutter build appbundle --dart-define-from-file=env.json` | `build/app/outputs/bundle/release/app-release.aab` |

Accept Android licenses if needed:

```bash
flutter doctor --android-licenses
```

## Code generation

Several files are generated and must be regenerated after schema or localization changes.

| What                    | Command                                                    |
| ----------------------- | ---------------------------------------------------------- |
| Localization (i18n)     | `flutter gen-l10n`                                         |
| Database models (Drift) | `dart run build_runner build --delete-conflicting-outputs` |
| Launcher icons          | `dart run flutter_launcher_icons`                          |
| Splash screen           | `dart run flutter_native_splash:create`                    |

## Project structure

```text
lib/
├── core/           # Utilities: logger, debouncer, timers, form helpers
├── domains/        # Business logic (Riverpod StateNotifiers)
│   ├── showerhead_domain.dart   # BLE scan, connect, live session, sync
│   ├── user_domain.dart         # User settings
│   └── app_domain.dart          # App-level state
├── models/         # Pure data classes
├── repositories/
│   ├── ble/        # Bluetooth Low Energy layer (flutter_blue_plus)
│   └── db/         # Local SQLite persistence (Drift)
├── l10n/           # Localization (English & French ARB files)
├── constants.dart  # BLE UUIDs, app-wide constants, country settings
└── main.dart       # App entry point
```

## Supported Hydrao products

| Product       | Type key |
| ------------- | -------- |
| Hydrao Aloe   | `aloe`   |
| Hydrao Cereus | `cereus` |
| Hydrao First  | `first`  |
| Hydrao Yucca  | `yucca`  |

## Contributing

Contributions are welcome. Please open an issue before submitting a pull request for significant changes.

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Commit your changes
4. Open a pull request against `main`

Please follow the existing code style and run `flutter analyze` before submitting.

## License

This project is licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE) file for details.

Copyright 2026 Hydrao. See [NOTICE](NOTICE) for attribution requirements.
