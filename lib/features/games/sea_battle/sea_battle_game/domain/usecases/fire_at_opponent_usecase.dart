import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// Fires the player's shot at a cell of the opponent's board and returns
/// what it did, as the opponent reports it.
class FireAtOpponentUseCase {
  const FireAtOpponentUseCase(this._seaBattleOpponentRepository);

  final SeaBattleOpponentRepository _seaBattleOpponentRepository;

  Future<ShotEntity> call(BoardCoordinate cell) =>
      _seaBattleOpponentRepository.answerPlayerShot(cell);
}
