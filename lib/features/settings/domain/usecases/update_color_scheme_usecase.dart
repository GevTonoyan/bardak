import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/settings/domain/repositories/settings_repository.dart';

/// Persists the selected color scheme.
class UpdateColorSchemeUseCase {
  const UpdateColorSchemeUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  Future<bool> call(AppColorScheme colorScheme) =>
      _settingsRepository.updateColorScheme(colorScheme);
}
