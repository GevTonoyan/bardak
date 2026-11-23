import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/repositories/sea_battle_settings_repository.dart';

/// Persists the selected sea battle bot difficulty.
class UpdateSeaBattleBotDifficultyUseCase {
  const UpdateSeaBattleBotDifficultyUseCase(this._seaBattleSettingsRepository);

  final SeaBattleSettingsRepository _seaBattleSettingsRepository;

  Future<bool> call(SeaBattleBotDifficulty botDifficulty) =>
      _seaBattleSettingsRepository.updateBotDifficulty(botDifficulty);
}
