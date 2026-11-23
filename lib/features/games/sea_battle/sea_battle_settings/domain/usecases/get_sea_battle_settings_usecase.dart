import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/repositories/sea_battle_settings_repository.dart';

/// Gets the persisted sea battle settings.
class GetSeaBattleSettingsUseCase {
  const GetSeaBattleSettingsUseCase(this._seaBattleSettingsRepository);

  final SeaBattleSettingsRepository _seaBattleSettingsRepository;

  SeaBattleSettingsEntity call() =>
      _seaBattleSettingsRepository.getSeaBattleSettings();
}
