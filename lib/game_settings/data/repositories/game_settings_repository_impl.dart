import 'package:bardak/game_settings/data/data_sources/game_settings_local_data_source.dart';
import 'package:bardak/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';

class GameSettingsRepositoryImpl implements GameSettingsRepository {
  const GameSettingsRepositoryImpl({required this.dataSource});

  final GameSettingsLocalDataSource dataSource;

  @override
  GameSettingsEntity getGameSettings() => dataSource.getGameSettings();

  @override
  Future<bool> updateRoundDuration(int roundDuration) =>
      dataSource.updateRoundDuration(roundDuration);

  @override
  Future<bool> updatePointsToWin(int pointsToWin) =>
      dataSource.updatePointsToWin(pointsToWin);

  @override
  Future<bool> updateAllowSkipping({required bool allowSkipping}) =>
      dataSource.updateAllowSkipping(allowSkipping: allowSkipping);
}
