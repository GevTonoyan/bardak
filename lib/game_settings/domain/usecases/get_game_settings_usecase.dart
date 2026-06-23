import 'package:bardak/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';

/// Reads the stored game settings.
class GetGameSettingsUseCase {
  const GetGameSettingsUseCase(this._repository);

  final GameSettingsRepository _repository;

  GameSettingsEntity call() => _repository.getGameSettings();
}
