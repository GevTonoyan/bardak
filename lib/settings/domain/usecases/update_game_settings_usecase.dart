import 'package:boardify/settings/domain/repositories/settings_repository.dart';

/// Use case for updating alias setting
class UpdateGameSettingSUseCase {
  const UpdateGameSettingSUseCase(this._aliasSettingsRepository);

  final SettingsRepository _aliasSettingsRepository;

  Future<bool> call(UpdateGameSettingsParams params) async {
    return _aliasSettingsRepository.updateGameSettings(params);
  }
}

/// Parameters for updating alias setting
class UpdateGameSettingsParams {
  const UpdateGameSettingsParams({required this.key, required this.value});

  final String key;
  final Object value;
}
