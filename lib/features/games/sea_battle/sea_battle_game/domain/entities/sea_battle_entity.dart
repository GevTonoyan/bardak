import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:equatable/equatable.dart';

/// A battle in progress: both boards, whose [turn] it is and the
/// [lastShot] fired.
///
/// A hit keeps the turn; a miss passes it to the other side. The first
/// side to sink the other's whole fleet wins.
class SeaBattleEntity extends Equatable {
  const SeaBattleEntity({
    required this.playerBoard,
    required this.opponentBoard,
    required this.turn,
    this.lastShot,
  });

  /// The player's fleet, shot at by the opponent.
  final SeaBattleBoardEntity playerBoard;

  /// The opponent's fleet, shot at by the player.
  final SeaBattleBoardEntity opponentBoard;

  /// The side that fires next.
  final SeaBattleSide turn;

  /// The most recent shot by either side; null before the first one.
  final ShotEntity? lastShot;

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

  /// The battle after the side whose [turn] it is fires at [cell]; what
  /// the shot did is in its [lastShot].
  ///
  /// [cell] must be one that [canFire].
  SeaBattleEntity fire(BoardCoordinate cell) {
    assert(canFire(turn, cell), '$turn cannot fire at $cell');

    final (target, result) = targetOf(turn).shoot(cell);
    final shot = ShotEntity(shooter: turn, cell: cell, result: result);
    final nextTurn = result.isHit ? turn : turn.other;

    return switch (turn) {
      .player => SeaBattleEntity(
        playerBoard: playerBoard,
        opponentBoard: target,
        turn: nextTurn,
        lastShot: shot,
      ),
      .opponent => SeaBattleEntity(
        playerBoard: target,
        opponentBoard: opponentBoard,
        turn: nextTurn,
        lastShot: shot,
      ),
    };
  }

  @override
  List<Object?> get props => [playerBoard, opponentBoard, turn, lastShot];
}

/// A shot fired by [shooter] at [cell] on the other side's board.
class ShotEntity extends Equatable {
  const ShotEntity({
    required this.shooter,
    required this.cell,
    required this.result,
  });

  final SeaBattleSide shooter;
  final BoardCoordinate cell;
  final ShotResult result;

  @override
  List<Object?> get props => [shooter, cell, result];
}

/// One of the two players in a battle.
enum SeaBattleSide {
  /// The person holding the phone.
  player,

  /// The bot, or the remote player online.
  opponent;

  /// The other side.
  SeaBattleSide get other => switch (this) {
    player => opponent,
    opponent => player,
  };
}
