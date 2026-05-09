# Bardak

Bardak – Your Pocket Board Game Hub!

A Flutter-based mobile board game app supporting Android and iOS.

## Prerequisites

- Flutter SDK `>=3.41.6`
- Dart SDK `^3.10.1`
- A Firebase project configured for Android and iOS

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/GevTonoyan/boardify.git
cd boardify
```

### 2. Set up Firebase

The Firebase configuration files are **not included** in the repository for security reasons. You need to generate them for your own Firebase project.

Run:

```bash
flutterfire configure
```

This will generate the following required files:

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

### 4. Run the app

```bash
flutter run
```

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

For TestFlight/App Store distribution, open `ios/Runner.xcworkspace` in Xcode and archive from there, or use the CI workflow.

## Project Structure

```
lib/
├── app_ui/          # Theme, widgets, UI components
├── card_round/      # Card-based game round logic
├── game_session/    # Game session management
├── home/            # Home screen
├── localizations/   # l10n / i18n (EN, RU, HY)
├── pre_game/        # Pre-game setup (teams, settings)
├── rewards/         # Reward system
├── router/          # GoRouter navigation
├── rules/           # Game rules
├── settings/        # App settings
├── single_word_round/ # Single-word game round logic
├── splash/          # Splash screen
├── themes/          # Color theme selection
├── utils/           # Constants, extensions, DI
└── word_pack/       # Word packs (Firestore + Hive cache)
```
