import 'package:boardify/app_ui/theme/app_color_scheme.dart';
import 'package:boardify/localizations/common/supported_locales.dart';
import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  const AppSettingsEntity({
    required this.isDarkMode,
    required this.locale,
    required this.colorScheme,
  });

  factory AppSettingsEntity.fromPreferences({
    String? locale,
    bool? isDarkMode,
    String? colorScheme,
  }) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? false,
      locale: AppLocales.fromString(locale),
      colorScheme: AppColorScheme.fromString(colorScheme),
    );
  }

  factory AppSettingsEntity.defaultSettings() {
    return const AppSettingsEntity(
      isDarkMode: false,
      locale: AppLocales.en,
      colorScheme: AppColorScheme.main,
    );
  }

  final bool isDarkMode;
  final AppLocales locale;
  final AppColorScheme colorScheme;

  AppSettingsEntity copyWith({
    bool? isDarkMode,
    AppLocales? locale,
    AppColorScheme? colorScheme,
  }) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  String toString() {
    return 'AppSettingsEntity(isDarkMode: $isDarkMode, locale: $locale, '
        'colorScheme: $colorScheme)';
  }

  @override
  List<Object?> get props => [isDarkMode, locale, colorScheme];
}
