import 'package:bardak/settings/domain/repositories/settings_repository.dart';

/// Persists whether sound effects are enabled.
class UpdateSoundEnabledUseCase {
  const UpdateSoundEnabledUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  Future<bool> call({required bool soundEnabled}) =>
      _settingsRepository.updateSoundEnabled(soundEnabled: soundEnabled);
}
