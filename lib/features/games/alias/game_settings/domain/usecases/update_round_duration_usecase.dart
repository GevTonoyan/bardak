import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';

/// Persists the round duration in seconds.
class UpdateRoundDurationUseCase {
  const UpdateRoundDurationUseCase(this._gameSettingsRepository);

  final GameSettingsRepository _gameSettingsRepository;

  Future<bool> call(int roundDuration) =>
      _gameSettingsRepository.updateRoundDuration(roundDuration);
}
