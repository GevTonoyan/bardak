import 'package:boardify/features/settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';

/// Use case to get the app settings from the repository
class GetAppSettingsUseCase {
  final SettingsRepository _settingsRepository;

  GetAppSettingsUseCase(this._settingsRepository);

  AppSettingsEntity call() {
    return _settingsRepository.getAppSettings();
  }
}
