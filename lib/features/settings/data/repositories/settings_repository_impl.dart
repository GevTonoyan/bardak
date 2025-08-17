import 'package:boardify/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:boardify/features/settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';
import 'package:boardify/features/settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';

/// This is the implementation of the [SettingsRepository] interface.
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource dataSource;

  const SettingsRepositoryImpl({required this.dataSource});

  @override
  GameSettingsEntity getGameSettings() => dataSource.getAliasSettings();

  @override
  Future<bool> updateGameSettings(UpdateGameSettingsParams params) async {
    final result = await dataSource.updateAliasSetting(params);
    return result;
  }

  @override
  AppSettingsEntity getAppSettings() {
    final settings = dataSource.getAppSettings();
    return settings;
  }

  @override
  Future<bool> updateAppSettings(UpdateAppSettingsParams params) async {
    final result = await dataSource.updateAppSettings(params);
    return result;
  }
}
