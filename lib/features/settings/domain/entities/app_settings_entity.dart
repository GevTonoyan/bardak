import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  const AppSettingsEntity({
    required this.locale,
    required this.colorScheme,
    required this.soundEnabled,
  });

  factory AppSettingsEntity.fromPreferences({
    String? locale,
    String? colorScheme,
    bool? soundEnabled,
  }) {
    return AppSettingsEntity(
      locale: AppLocale.fromString(locale),
      colorScheme: AppColorScheme.fromString(colorScheme),
      soundEnabled: soundEnabled ?? true,
    );
  }

  factory AppSettingsEntity.defaultSettings() {
    return const AppSettingsEntity(
      locale: AppLocale.en,
      colorScheme: AppColorScheme.main,
      soundEnabled: true,
    );
  }

  final AppLocale locale;
  final AppColorScheme colorScheme;
  final bool soundEnabled;

  AppSettingsEntity copyWith({
    AppLocale? locale,
    AppColorScheme? colorScheme,
    bool? soundEnabled,
  }) {
    return AppSettingsEntity(
      locale: locale ?? this.locale,
      colorScheme: colorScheme ?? this.colorScheme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  String toString() {
    return 'AppSettingsEntity(locale: $locale, '
        'colorScheme: $colorScheme, soundEnabled: $soundEnabled)';
  }

  @override
  List<Object?> get props => [locale, colorScheme, soundEnabled];
}
