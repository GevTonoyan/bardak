import 'package:bardak/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/game_settings/domain/usecases/update_game_settings_usecase.dart';

/// Contract for reading and persisting the Alias game settings.
abstract interface class GameSettingsRepository {
  /// Retrieves the currently stored game settings.
  GameSettingsEntity getGameSettings();

  /// Updates a single game setting. Returns true if the write succeeded.
  Future<bool> updateGameSettings(UpdateGameSettingsParams params);
}
