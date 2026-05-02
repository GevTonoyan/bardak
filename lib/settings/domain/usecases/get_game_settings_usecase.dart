import 'package:bardak/settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/settings/domain/repositories/settings_repository.dart';

class GetGameSettingsUseCase {
  const GetGameSettingsUseCase(this.aliasSettingsRepository);

  final SettingsRepository aliasSettingsRepository;

  GameSettingsEntity call() => aliasSettingsRepository.getGameSettings();
}
