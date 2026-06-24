import 'package:bardak/settings/domain/repositories/settings_repository.dart';

class UpdateAppSettingsUseCase {
  const UpdateAppSettingsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  Future<bool> call(UpdateAppSettingsParams params) =>
      _settingsRepository.updateAppSettings(params);
}

class UpdateAppSettingsParams {
  const UpdateAppSettingsParams({required this.key, required this.value});

  final String key;
  final Object value;
}
