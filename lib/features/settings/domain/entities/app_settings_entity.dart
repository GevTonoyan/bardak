import 'package:boardify/core/localizations/common/supported_locales.dart';
import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  final bool isDarkMode;
  final AppLocales locale;

  const AppSettingsEntity({required this.isDarkMode, required this.locale});

  AppSettingsEntity copyWith({bool? isDarkMode, AppLocales? locale}) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
    );
  }

  factory AppSettingsEntity.fromPreferences({
    String? locale,
    bool? isDarkMode,
  }) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? false,
      locale: AppLocales.fromString(locale),
    );
  }

  factory AppSettingsEntity.defaultSettings() {
    return AppSettingsEntity(isDarkMode: false, locale: AppLocales.en);
  }

  @override
  String toString() {
    return 'AppSettingsEntity(isDarkMode: $isDarkMode, locale: $locale)';
  }

  @override
  List<Object?> get props => [isDarkMode, locale];
}
