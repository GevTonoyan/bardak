import 'package:bardak/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/settings/domain/repositories/settings_repository.dart';

/// Persists the selected color scheme.
class UpdateColorSchemeUseCase {
  const UpdateColorSchemeUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  Future<bool> call(AppColorScheme colorScheme) =>
      _settingsRepository.updateColorScheme(colorScheme);
}
