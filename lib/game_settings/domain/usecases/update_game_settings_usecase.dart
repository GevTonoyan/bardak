import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';

/// Updates a single game setting identified by its preference key.
class UpdateGameSettingsUseCase {
  const UpdateGameSettingsUseCase(this._repository);

  final GameSettingsRepository _repository;

  Future<bool> call(UpdateGameSettingsParams params) =>
      _repository.updateGameSettings(params);
}

class UpdateGameSettingsParams {
  const UpdateGameSettingsParams({required this.key, required this.value});

  final String key;
  final Object value;
}
