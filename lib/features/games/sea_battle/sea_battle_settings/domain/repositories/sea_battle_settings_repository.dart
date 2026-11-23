import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';

abstract interface class SeaBattleSettingsRepository {
  /// Retrieves the currently stored sea battle settings.
  SeaBattleSettingsEntity getSeaBattleSettings();

  /// Persists the selected mode.
  Future<bool> updateMode(SeaBattleMode mode);

  /// Persists the selected bot difficulty.
  Future<bool> updateBotDifficulty(SeaBattleBotDifficulty botDifficulty);
}
