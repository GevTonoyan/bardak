import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';

/// Persists the number of spies.
class UpdateSpyCountUseCase {
  const UpdateSpyCountUseCase(this._spySettingsRepository);

  final SpySettingsRepository _spySettingsRepository;

  Future<bool> call(int spyCount) =>
      _spySettingsRepository.updateSpyCount(spyCount);
}
