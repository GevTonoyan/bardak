import 'package:boardify/features/settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';

/// Use case to get the app settings from the repository
class GetAppSettingsUseCase {
  GetAppSettingsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  AppSettingsEntity call() {
    return _settingsRepository.getAppSettings();
  }
}
