import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_game_settings_usecase.dart';

/// This is the implementation of the [AliasSettingsRepository] interface.
class AliasSettingsRepositoryImpl implements AliasSettingsRepository {
  final AliasSettingsLocalDataSource dataSource;

  const AliasSettingsRepositoryImpl({required this.dataSource});

  @override
  GameSettingsEntity getGameSettings() => dataSource.getAliasSettings();

  @override
  Future<bool> updateGameSettings(UpdateAliasSettingParams params) async {
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
