import 'package:bardak/settings/data/data_sources/settings_local_data_source.dart';
import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/repositories/settings_repository.dart';
import 'package:bardak/settings/domain/usecases/update_app_settings_usecase.dart';

/// This is the implementation of the [SettingsRepository] interface.
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.dataSource});

  final SettingsLocalDataSource dataSource;

  @override
  AppSettingsEntity getAppSettings() => dataSource.getAppSettings();

  @override
  Future<bool> updateAppSettings(UpdateAppSettingsParams params) {
    return dataSource.updateAppSettings(params);
  }
}
