import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';

/// Persists the number of players.
class UpdatePlayerCountUseCase {
  const UpdatePlayerCountUseCase(this._spySettingsRepository);

  final SpySettingsRepository _spySettingsRepository;

  Future<bool> call(int playerCount) =>
      _spySettingsRepository.updatePlayerCount(playerCount);
}
