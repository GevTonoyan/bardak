import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/repositories/sea_battle_settings_repository.dart';

/// Persists the selected sea battle mode.
class UpdateSeaBattleModeUseCase {
  const UpdateSeaBattleModeUseCase(this._seaBattleSettingsRepository);

  final SeaBattleSettingsRepository _seaBattleSettingsRepository;

  Future<bool> call(SeaBattleMode mode) =>
      _seaBattleSettingsRepository.updateMode(mode);
}
