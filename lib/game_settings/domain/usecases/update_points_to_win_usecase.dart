import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';

/// Persists the points required to win.
class UpdatePointsToWinUseCase {
  const UpdatePointsToWinUseCase(this._gameSettingsRepository);

  final GameSettingsRepository _gameSettingsRepository;

  Future<bool> call(int pointsToWin) =>
      _gameSettingsRepository.updatePointsToWin(pointsToWin);
}
