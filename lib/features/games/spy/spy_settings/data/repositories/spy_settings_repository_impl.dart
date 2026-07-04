import 'package:bardak/features/games/spy/spy_settings/data/data_sources/spy_settings_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';

/// Implementation of [SpySettingsRepository].
class SpySettingsRepositoryImpl implements SpySettingsRepository {
  const SpySettingsRepositoryImpl({required this._dataSource});

  final SpySettingsLocalDataSource _dataSource;

  @override
  SpySettingsEntity getSpySettings() => _dataSource.getSpySettings();

  @override
  Future<bool> updatePlayerCount(int playerCount) =>
      _dataSource.updatePlayerCount(playerCount);

  @override
  Future<bool> updateSpyCount(int spyCount) =>
      _dataSource.updateSpyCount(spyCount);

  @override
  Future<bool> updateRoundDuration(int roundDuration) =>
      _dataSource.updateRoundDuration(roundDuration);
}
