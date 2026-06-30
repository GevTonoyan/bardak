import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract local data source for purchased themes.
abstract interface class PurchasedThemesLocalDataSource {
  /// Returns the list of themes the user owns.
  List<AppColorScheme> getPurchasedThemes();

  /// Persists the updated list of purchased themes.
  Future<bool> updatePurchasedThemes(List<AppColorScheme> themes);
}

/// Color schemes every user owns by default, before any purchases.
const _defaultThemes = <AppColorScheme>[.main, .blue, .dark];

/// Implementation that reads/writes purchased themes from [SharedPreferences].
class PurchasedThemesLocalDataSourceImpl
    implements PurchasedThemesLocalDataSource {
  const PurchasedThemesLocalDataSourceImpl({required this.preferences});

  static const _purchasedThemesKey = 'purchased_themes';

  final SharedPreferences preferences;

  @override
  List<AppColorScheme> getPurchasedThemes() {
    final stored = preferences.getStringList(_purchasedThemesKey);

    if (stored == null) return List.of(_defaultThemes);

    return stored.map(AppColorScheme.fromString).toList();
  }

  @override
  Future<bool> updatePurchasedThemes(List<AppColorScheme> themes) {
    final encoded = themes.map((e) => e.name).toList();
    return preferences.setStringList(
      _purchasedThemesKey,
      encoded,
    );
  }
}
