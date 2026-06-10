# Run Code Generation

Run all code generation tasks for the Bardak Flutter project.

## Usage

`/run-gen`

---

## Steps

Run in sequence:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

After running, check for any generation errors and report them.

Common reasons to run this:
- Added new assets to `pubspec.yaml`
- Added/edited `.arb` localization files
- Added Hive type adapters
- Added new `flutter_gen` assets
