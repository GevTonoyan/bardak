import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';

/// Base class for all events related to purchased themes.
sealed class ThemesEvent {
  const ThemesEvent();
}

/// Purchases a new theme and persists the updated list.
class PurchaseTheme extends ThemesEvent {
  const PurchaseTheme({required this.theme});

  final AppColorScheme theme;
}
