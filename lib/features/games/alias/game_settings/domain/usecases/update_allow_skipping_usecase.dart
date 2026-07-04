import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';

/// Persists whether skipping words is allowed.
class UpdateAllowSkippingUseCase {
  const UpdateAllowSkippingUseCase(this._gameSettingsRepository);

  final GameSettingsRepository _gameSettingsRepository;

  Future<bool> call({required bool allowSkipping}) =>
      _gameSettingsRepository.updateAllowSkipping(allowSkipping: allowSkipping);
}
