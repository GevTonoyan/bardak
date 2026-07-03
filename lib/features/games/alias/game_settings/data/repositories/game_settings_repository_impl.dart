import 'package:bardak/features/games/alias/game_settings/data/data_sources/game_settings_local_data_source.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';

class GameSettingsRepositoryImpl implements GameSettingsRepository {
  const GameSettingsRepositoryImpl({required this._dataSource});

  final GameSettingsLocalDataSource _dataSource;

  @override
  GameSettingsEntity getGameSettings() => _dataSource.getGameSettings();

  @override
  Future<bool> updateGameMode(GameMode gameMode) =>
      _dataSource.updateGameMode(gameMode);

  @override
  Future<bool> updateRoundDuration(int roundDuration) =>
      _dataSource.updateRoundDuration(roundDuration);

  @override
  Future<bool> updatePointsToWin(int pointsToWin) =>
      _dataSource.updatePointsToWin(pointsToWin);

  @override
  Future<bool> updateAllowSkipping({required bool allowSkipping}) =>
      _dataSource.updateAllowSkipping(allowSkipping: allowSkipping);
}
