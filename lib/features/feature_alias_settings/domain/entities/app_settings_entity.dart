import 'package:boardify/core/localizations/common/supported_locales.dart';

class AppSettingsEntity {
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (runtimeType != other.runtimeType) return false;

    return other is AppSettingsEntity &&
        other.isDarkMode == isDarkMode &&
        other.locale == locale;
  }

  @override
  int get hashCode => isDarkMode.hashCode ^ locale.hashCode;

  @override
  String toString() {
    return 'SettingsEntity(isDarkMode: $isDarkMode, locale: $locale)';
  }
}
