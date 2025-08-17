import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';

/// Use case for updating alias setting
class UpdateGameSettingSUseCase {
  final SettingsRepository _aliasSettingsRepository;

  const UpdateGameSettingSUseCase(this._aliasSettingsRepository);

  Future<bool> call(UpdateGameSettingsParams params) async {
    return await _aliasSettingsRepository.updateGameSettings(params);
  }
}

/// Parameters for updating alias setting
class UpdateGameSettingsParams {
  final String key;
  final Object value;

  const UpdateGameSettingsParams({required this.key, required this.value});
}
