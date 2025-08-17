import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';

class UpdateAppSettingsUseCase {
  final AliasSettingsRepository settingsRepository;

  const UpdateAppSettingsUseCase(this.settingsRepository);

  Future<bool> call(UpdateAppSettingsParams params) async {
    final result = await settingsRepository.updateAppSettings(params);
    return result;
  }
}

class UpdateAppSettingsParams {
  final String key;
  final Object value;

  const UpdateAppSettingsParams({required this.key, required this.value});
}
