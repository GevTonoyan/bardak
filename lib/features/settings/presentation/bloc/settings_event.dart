import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/common/supported_locales.dart';
import 'package:equatable/equatable.dart';

/// Base class for all events related to settings.
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the persisted app settings into state.
class LoadAppSettings extends SettingsEvent {
  const LoadAppSettings();
}

class ChangeColorScheme extends SettingsEvent {
  const ChangeColorScheme({required this.colorScheme});

  final AppColorScheme colorScheme;

  @override
  List<Object?> get props => [colorScheme];
}

class ChangeLocale extends SettingsEvent {
  const ChangeLocale(this.locale);

  final AppLocales locale;

  @override
  List<Object?> get props => [locale];
}

class ChangeSoundEnabled extends SettingsEvent {
  const ChangeSoundEnabled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class OpenStoreListing extends SettingsEvent {
  const OpenStoreListing();
}
