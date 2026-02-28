import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:alias_pro/localizations/common/supported_locales.dart';
import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  const AppSettingsEntity({
    required this.isDarkMode,
    required this.locale,
    required this.colorScheme,
    required this.soundEnabled,
  });

  factory AppSettingsEntity.fromPreferences({
    String? locale,
    bool? isDarkMode,
    String? colorScheme,
    bool? soundEnabled,
  }) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? false,
      locale: AppLocales.fromString(locale),
      colorScheme: AppColorScheme.fromString(colorScheme),
      soundEnabled: soundEnabled ?? true,
    );
  }

  factory AppSettingsEntity.defaultSettings() {
    return const AppSettingsEntity(
      isDarkMode: false,
      locale: AppLocales.en,
      colorScheme: AppColorScheme.main,
      soundEnabled: true,
    );
  }

  final bool isDarkMode;
  final AppLocales locale;
  final AppColorScheme colorScheme;
  final bool soundEnabled;

  AppSettingsEntity copyWith({
    bool? isDarkMode,
    AppLocales? locale,
    AppColorScheme? colorScheme,
    bool? soundEnabled,
  }) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
      colorScheme: colorScheme ?? this.colorScheme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  String toString() {
    return 'AppSettingsEntity(isDarkMode: $isDarkMode, locale: $locale, '
        'colorScheme: $colorScheme, soundEnabled: $soundEnabled)';
  }

  @override
  List<Object?> get props => [isDarkMode, locale, colorScheme, soundEnabled];
}
