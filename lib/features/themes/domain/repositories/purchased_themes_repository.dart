import 'package:bardak/core/app_ui/theme/app_color_scheme.dart';

/// Abstract repository for purchased themes operations.
abstract interface class PurchasedThemesRepository {
  /// Returns the list of themes the user has purchased (or owns by default).
  List<AppColorScheme> getPurchasedThemes();

  /// Persists the updated list of purchased themes.
  Future<bool> updatePurchasedThemes(List<AppColorScheme> themes);
}
