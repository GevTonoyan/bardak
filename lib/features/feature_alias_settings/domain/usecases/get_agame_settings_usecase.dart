import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';

class GetGameSettingsUseCase {
  final AliasSettingsRepository aliasSettingsRepository;

  GetGameSettingsUseCase(this.aliasSettingsRepository);

  GameSettingsEntity call() => aliasSettingsRepository.getGameSettings();
}
