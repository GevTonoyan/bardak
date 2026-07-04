import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';

/// Persists the selected game mode.
class UpdateGameModeUseCase {
  const UpdateGameModeUseCase(this._gameSettingsRepository);

  final GameSettingsRepository _gameSettingsRepository;

  Future<bool> call(GameMode gameMode) =>
      _gameSettingsRepository.updateGameMode(gameMode);
}
