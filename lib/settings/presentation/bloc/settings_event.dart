import 'package:bardak/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/localizations/common/supported_locales.dart';

/// Base class for all events related to settings.
sealed class SettingsEvent {
  const SettingsEvent();
}

class GetAppSettings extends SettingsEvent {
  const GetAppSettings();
}

class ChangeColorScheme extends SettingsEvent {
  const ChangeColorScheme({required this.colorScheme});

  final AppColorScheme colorScheme;
}

class ChangeLocale extends SettingsEvent {
  const ChangeLocale(this.locale);

  final AppLocales locale;
}

class ChangeSoundEffects extends SettingsEvent {
  const ChangeSoundEffects({required this.soundEffects});

  final bool soundEffects;
}

class OpenStoreListingRequested extends SettingsEvent {
  const OpenStoreListingRequested();
}
