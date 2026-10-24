# Bardak

Bardak – Your Pocket Board Games!

A Flutter mobile app for Android and iOS that bundles several party and
puzzle games in one place.

## Games

| Game | Description |
|------|-------------|
| **Alias** | Team word-guessing game with card (multiple words) and single-word round modes, word packs and team setup |
| **Spy** | Social deduction game with location packs, including player-created custom packs |
| **Sudoku** | Classic Sudoku with difficulty levels, mistake tracking and win stats |

Every game ships with its own settings and a swipeable "how to play" rules
carousel.

### App-wide features

- 15 switchable color themes
- Localization: English, Russian, Armenian
- Sound effects, in-app review prompts, native splash screen
- Offline play — word packs are fetched from Firestore and cached locally

## Tech Stack

| Area | Tools |
|------|-------|
| Framework | Flutter, Dart |
| State management | BLoC (`flutter_bloc`, `bloc_concurrency`) |
| Architecture | Clean Architecture (domain / data / presentation) |
| Dependency injection | `get_it` |
| Navigation | `go_router` |
| Remote data | Firebase Cloud Firestore |
| Local storage | Hive, SharedPreferences |
| Code generation | `flutter_gen`, `build_runner`, `flutter gen-l10n` |
| Testing | `flutter_test`, `bloc_test`, `mocktail`, `fake_cloud_firestore` |
| Linting | `very_good_analysis` |
| CI | GitHub Actions (Android APK/AAB + iOS builds) |

## Prerequisites

- Flutter SDK `>=3.44.5`
- Dart SDK `3.12.2`
- A Firebase project configured for Android and iOS

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/GevTonoyan/bardak.git
cd bardak
```

### 2. Set up Firebase

The Firebase configuration files are **not included** in the repository for
security reasons. Generate them for your own Firebase project:

```bash
flutterfire configure
```

This generates the following required files:

| File | Description |
|------|-------------|
| `android/app/google-services.json` | Firebase config for Android |
| `ios/Runner/GoogleService-Info.plist` | Firebase config for iOS |
| `lib/firebase_options.dart` | Dart Firebase options |
| `firebase.json` | Firebase project config |

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate code

```bash
dart run build_runner build --delete-conflicting-outputs   # asset references
flutter gen-l10n                                           # localizations
```

### 5. Run the app

```bash
flutter run
```

## Development

```bash
flutter analyze        # lint check
dart format lib/       # format code
flutter test           # run tests
```

Localization `.arb` files live in `lib/core/localizations/l10n/`. Run
`flutter gen-l10n` after editing them.

## Building for Release

### Android

To build a signed release APK or App Bundle, you need a keystore file.

**1. Create a keystore** (if you don't have one):

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**2. Create `android/key.properties`** with your keystore credentials:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=<your-key-alias>
storeFile=<path-to-your-keystore.jks>
```

> ⚠️ Do **not** commit `key.properties` to version control.

**3. Build:**

```bash
flutter build appbundle --release   # App Bundle (for Play Store)
flutter build apk --release         # APK
```

### iOS

```bash
flutter build ios --release
```

For TestFlight/App Store distribution, open `ios/Runner.xcworkspace` in Xcode
and archive from there.

### CI

`.github/workflows/build.yml` builds the Android APK/AAB and an unsigned iOS
release build. It is triggered manually (`workflow_dispatch`) from the GitHub
Actions tab.

## Project Structure

```
lib/
├── core/
│   ├── app_ui/          # Design system: colors, typography, shared widgets
│   ├── di/              # GetIt setup
│   ├── extensions/      # Dart/Flutter extensions
│   ├── generated/       # flutter_gen output (assets)
│   ├── localizations/   # l10n (EN, RU, AM)
│   ├── logging/         # Logging utilities
│   └── router/          # GoRouter configuration
├── features/
│   ├── app_review/      # In-app review prompts
│   ├── games/
│   │   ├── alias/       # card_round, game_session, game_settings, rules,
│   │   │                # single_word_round, team_setup, word_packs
│   │   ├── spy/         # spy_packs, spy_rules, spy_session, spy_settings
│   │   └── sudoku/      # sudoku_game, sudoku_rules, sudoku_settings
│   ├── home/            # Home screen / game picker
│   ├── settings/        # App settings
│   ├── splash/          # Splash screen
│   └── themes/          # Color theme selection
└── main.dart
```

Each feature follows Clean Architecture:

```
feature_x/
├── domain/        # entities, repository interfaces, use cases (pure Dart)
├── data/          # data sources + repository implementations
├── presentation/  # bloc/ + ui/
└── feature_x_scope.dart   # GetIt registrations
```

Presentation-only features (home, splash, themes) omit `domain/` and `data/`.
