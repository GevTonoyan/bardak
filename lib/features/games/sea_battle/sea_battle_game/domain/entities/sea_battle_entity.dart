import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_side.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_result.dart';
import 'package:equatable/equatable.dart';

/// A battle in progress: both boards and whose [turn] it is.
///
/// A hit keeps the turn; a miss passes it to the other side. The first
/// side to sink the other's whole fleet wins.
class SeaBattleEntity extends Equatable {
  const SeaBattleEntity({
    required this.playerBoard,
    required this.opponentBoard,
    required this.turn,
  });

  /// The player's fleet, shot at by the opponent.
  final SeaBattleBoardEntity playerBoard;

  /// The opponent's fleet, shot at by the player.
  final SeaBattleBoardEntity opponentBoard;

  /// The side that fires next.
  final SeaBattleSide turn;

  /// The board [shooter] fires at.
  SeaBattleBoardEntity targetOf(SeaBattleSide shooter) => switch (shooter) {
    .player => opponentBoard,
    .opponent => playerBoard,
  };

  /// The side that sank the other's whole fleet, once the battle is over.
  SeaBattleSide? get winner {
    if (opponentBoard.isDefeated) return .player;
    if (playerBoard.isDefeated) return .opponent;
    return null;
  }

  bool get isOver => winner != null;

  /// Whether [shooter] may fire at [cell] now.
  bool canFire(SeaBattleSide shooter, BoardCoordinate cell) =>
      !isOver && turn == shooter && targetOf(shooter).canShoot(cell);

  /// The battle after the side whose [turn] it is fires at [cell], and
  /// what the shot did.
  ///
  /// [cell] must be one that [canFire].
  (SeaBattleEntity, ShotResult) fire(BoardCoordinate cell) {
    assert(canFire(turn, cell), '$turn cannot fire at $cell');

    final (target, result) = targetOf(turn).shoot(cell);
    final nextTurn = result.isHit ? turn : turn.other;

    final battle = switch (turn) {
      .player => SeaBattleEntity(
        playerBoard: playerBoard,
        opponentBoard: target,
        turn: nextTurn,
      ),
      .opponent => SeaBattleEntity(
        playerBoard: target,
        opponentBoard: opponentBoard,
        turn: nextTurn,
      ),
    };
    return (battle, result);
  }

  @override
  List<Object?> get props => [playerBoard, opponentBoard, turn];
}
