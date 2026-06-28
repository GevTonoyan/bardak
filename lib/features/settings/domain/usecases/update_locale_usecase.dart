import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/settings/domain/repositories/settings_repository.dart';

/// Persists the selected app locale.
class UpdateLocaleUseCase {
  const UpdateLocaleUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  Future<bool> call(AppLocale locale) =>
      _settingsRepository.updateLocale(locale);
}
