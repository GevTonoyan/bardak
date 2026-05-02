import 'package:bardak/settings/domain/repositories/settings_repository.dart';

/// Use case for updating alias setting
class UpdateGameSettingSUseCase {
  const UpdateGameSettingSUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  Future<bool> call(UpdateGameSettingsParams params) async {
    return _settingsRepository.updateGameSettings(params);
  }
}

/// Parameters for updating alias setting
class UpdateGameSettingsParams {
  const UpdateGameSettingsParams({required this.key, required this.value});

  final String key;
  final Object value;
}
