import 'package:boardify/features/feature_alias_settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_game_settings_usecase.dart';

/// This is the interface for the [AliasSettingsRepository].
abstract interface class AliasSettingsRepository {
  /// Gets the app settings.
  AppSettingsEntity getAppSettings();

  /// Updates a setting with the given [key] and [value].
  Future<bool> updateAppSettings(UpdateAppSettingsParams params);

  /// This method is used to get the alias settings.
  GameSettingsEntity getGameSettings();

  /// This method is used to update the alias settings.
  Future<bool> updateGameSettings(UpdateAliasSettingParams params);
}
