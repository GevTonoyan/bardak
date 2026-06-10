# Check

Run a full health check on the Bardak project.

## Usage

`/check`

---

## Steps

Run all of the following and report results:

```bash
dart format lib/ --set-exit-if-changed
flutter analyze
flutter test
```

Report:
1. Format violations (files that need formatting)
2. Analyzer warnings/errors — grouped by severity
3. Test results

Note: `very_good_analysis` warnings are expected and tracked — flag new ones introduced since the last commit but do not treat existing ones as blockers.
