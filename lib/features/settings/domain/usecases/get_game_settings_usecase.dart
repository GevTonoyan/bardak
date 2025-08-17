import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';

class GetGameSettingsUseCase {
  final SettingsRepository aliasSettingsRepository;

  const GetGameSettingsUseCase(this.aliasSettingsRepository);

  GameSettingsEntity call() => aliasSettingsRepository.getGameSettings();
}
