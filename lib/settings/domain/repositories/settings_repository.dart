import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/usecases/update_app_settings_usecase.dart';

/// This is the interface for the [SettingsRepository].
abstract interface class SettingsRepository {
  /// Gets the app settings.
  AppSettingsEntity getAppSettings();

  /// Updates a setting with the given key and value.
  Future<bool> updateAppSettings(UpdateAppSettingsParams params);
}
