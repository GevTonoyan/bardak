import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';

/// Updates a single game setting identified by its preference key.
class UpdateGameSettingsUseCase {
  const UpdateGameSettingsUseCase(this._gameSettingsRepository);

  final GameSettingsRepository _gameSettingsRepository;

  Future<bool> call(UpdateGameSettingsParams params) =>
      _gameSettingsRepository.updateGameSettings(params);
}

class UpdateGameSettingsParams {
  const UpdateGameSettingsParams({required this.key, required this.value});

  final String key;
  final Object value;
}
