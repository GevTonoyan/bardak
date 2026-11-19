import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// Tells the opponent what its shot did on the player's board.
class ReportOpponentShotUseCase {
  const ReportOpponentShotUseCase(this._seaBattleOpponentRepository);

  final SeaBattleOpponentRepository _seaBattleOpponentRepository;

  Future<void> call(ShotEntity shot) =>
      _seaBattleOpponentRepository.reportOpponentShot(shot);
}
