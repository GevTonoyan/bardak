import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';

/// Reads the stored game settings.
class GetGameSettingsUseCase {
  const GetGameSettingsUseCase(this._gameSettingsRepository);

  final GameSettingsRepository _gameSettingsRepository;

  GameSettingsEntity call() => _gameSettingsRepository.getGameSettings();
}
