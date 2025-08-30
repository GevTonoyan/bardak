import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';

class UpdateAppSettingsUseCase {
  const UpdateAppSettingsUseCase(this.settingsRepository);

  final SettingsRepository settingsRepository;

  Future<bool> call(UpdateAppSettingsParams params) async {
    final result = await settingsRepository.updateAppSettings(params);
    return result;
  }
}

class UpdateAppSettingsParams {
  const UpdateAppSettingsParams({required this.key, required this.value});

  final String key;
  final Object value;
}
