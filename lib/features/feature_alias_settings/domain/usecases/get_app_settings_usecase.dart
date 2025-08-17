import 'package:boardify/features/feature_alias_settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';

/// Use case to get the app settings from the repository
class GetAppSettingsUseCase {
  final AliasSettingsRepository _settingsRepository;

  GetAppSettingsUseCase(this._settingsRepository);

  AppSettingsEntity call() {
    return _settingsRepository.getAppSettings();
  }
}
