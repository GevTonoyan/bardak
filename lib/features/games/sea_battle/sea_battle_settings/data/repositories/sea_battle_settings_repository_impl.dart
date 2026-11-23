import 'package:bardak/features/games/sea_battle/sea_battle_settings/data/data_sources/sea_battle_settings_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/repositories/sea_battle_settings_repository.dart';

class SeaBattleSettingsRepositoryImpl implements SeaBattleSettingsRepository {
  const SeaBattleSettingsRepositoryImpl({required this._dataSource});

  final SeaBattleSettingsLocalDataSource _dataSource;

  @override
  SeaBattleSettingsEntity getSeaBattleSettings() =>
      _dataSource.getSeaBattleSettings();

  @override
  Future<bool> updateMode(SeaBattleMode mode) => _dataSource.updateMode(mode);

  @override
  Future<bool> updateBotDifficulty(SeaBattleBotDifficulty botDifficulty) =>
      _dataSource.updateBotDifficulty(botDifficulty);
}
