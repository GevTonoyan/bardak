import 'package:boardify/core/localizations/common/supported_locales.dart';

class SettingsEntity {
  final bool isDarkMode;
  final AppLocales locale;

  const SettingsEntity({required this.isDarkMode, required this.locale});

  SettingsEntity copyWith({bool? isDarkMode, AppLocales? locale}) {
    return SettingsEntity(isDarkMode: isDarkMode ?? this.isDarkMode, locale: locale ?? this.locale);
  }

  factory SettingsEntity.fromPreferences({String? locale, bool? isDarkMode}) {
    return SettingsEntity(isDarkMode: isDarkMode ?? false, locale: AppLocales.fromString(locale));
  }

  factory SettingsEntity.defaultSettings() {
    return SettingsEntity(isDarkMode: false, locale: AppLocales.en);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (runtimeType != other.runtimeType) return false;

    return other is SettingsEntity && other.isDarkMode == isDarkMode && other.locale == locale;
  }

  @override
  int get hashCode => isDarkMode.hashCode ^ locale.hashCode;

  @override
  String toString() {
    return 'SettingsEntity(isDarkMode: $isDarkMode, locale: $locale)';
  }
}
