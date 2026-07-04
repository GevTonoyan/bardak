import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/features/settings/domain/repositories/settings_repository.dart';

/// Reads the stored app settings.
class GetAppSettingsUseCase {
  const GetAppSettingsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  AppSettingsEntity call() => _settingsRepository.getAppSettings();
}
