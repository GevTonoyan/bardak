import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Sea Battle game settings in [SharedPreferences].
abstract interface class SeaBattleSettingsLocalDataSource {
  /// Retrieves the sea battle settings from shared preferences.
  SeaBattleSettingsEntity getSeaBattleSettings();

  Future<bool> updateMode(SeaBattleMode mode);

  Future<bool> updateBotDifficulty(SeaBattleBotDifficulty botDifficulty);
}

class SeaBattleSettingsLocalDataSourceImpl
    implements SeaBattleSettingsLocalDataSource {
  const SeaBattleSettingsLocalDataSourceImpl({required this._preferences});

  static const _modeKey = 'sea_battle_mode';
  static const _botDifficultyKey = 'sea_battle_bot_difficulty';

  final SharedPreferences _preferences;

  @override
  SeaBattleSettingsEntity getSeaBattleSettings() {
    // Missing keys fall back to the entity's constructor defaults.
    const defaults = SeaBattleSettingsEntity();

    return SeaBattleSettingsEntity(
      mode: SeaBattleMode.fromString(
        _preferences.getString(_modeKey) ?? defaults.mode.name,
      ),
      botDifficulty: SeaBattleBotDifficulty.fromString(
        _preferences.getString(_botDifficultyKey) ??
            defaults.botDifficulty.name,
      ),
    );
  }

  @override
  Future<bool> updateMode(SeaBattleMode mode) {
    return _preferences.setString(_modeKey, mode.name);
  }

  @override
  Future<bool> updateBotDifficulty(SeaBattleBotDifficulty botDifficulty) {
    return _preferences.setString(_botDifficultyKey, botDifficulty.name);
  }
}
