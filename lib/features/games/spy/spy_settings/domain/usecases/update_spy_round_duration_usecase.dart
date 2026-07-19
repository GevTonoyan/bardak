import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';

/// Persists the Spy round duration in seconds.
class UpdateSpyRoundDurationUseCase {
  const UpdateSpyRoundDurationUseCase(this._spySettingsRepository);

  final SpySettingsRepository _spySettingsRepository;

  Future<bool> call(int roundDuration) =>
      _spySettingsRepository.updateRoundDuration(roundDuration);
}
