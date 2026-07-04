import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';

/// Reads the current spy settings.
class GetSpySettingsUseCase {
  const GetSpySettingsUseCase(this._spySettingsRepository);

  final SpySettingsRepository _spySettingsRepository;

  SpySettingsEntity call() => _spySettingsRepository.getSpySettings();
}
