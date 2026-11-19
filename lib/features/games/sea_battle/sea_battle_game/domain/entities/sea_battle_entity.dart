import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:equatable/equatable.dart';

/// A battle in progress: both boards, whose [turn] it is and the
/// [lastShot] fired.
///
/// The player's fleet is known; the opponent's is hidden until the battle
/// is over, so every shot is [record]ed with the result its target's owner
/// reported. A hit keeps the turn; a miss passes it to the other side. The
/// first side to sink the other's whole fleet wins.
class SeaBattleEntity extends Equatable {
  const SeaBattleEntity({
    required this.playerBoard,
    required this.opponentBoard,
    required this.turn,
    this.lastShot,
  });

  /// The player's fleet, shot at by the opponent.
  final SeaBattleBoardEntity playerBoard;

  /// The opponent's board, shot at by the player; its fleet stays hidden
  /// until the battle is over.
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

  /// The opponent's shot at [cell], answered from the player's own fleet.
  ShotEntity answerOpponentShot(BoardCoordinate cell) {
    final (result, sunkShip) = playerBoard.answer(cell);
    return ShotEntity(
      shooter: .opponent,
      cell: cell,
      result: result,
      sunkShip: sunkShip,
    );
  }

  /// The battle after [shot], fired by the side whose [turn] it is.
  SeaBattleEntity record(ShotEntity shot) {
    assert(
      canFire(shot.shooter, shot.cell),
      '${shot.shooter} cannot fire at ${shot.cell}',
    );

    final target = targetOf(shot.shooter).record(
      shot.cell,
      shot.result,
      sunkShip: shot.sunkShip,
    );
    final nextTurn = shot.result.isHit ? turn : turn.other;

    return SeaBattleEntity(
      playerBoard: shot.shooter == .opponent ? target : playerBoard,
      opponentBoard: shot.shooter == .player ? target : opponentBoard,
      turn: nextTurn,
      lastShot: shot,
    );
  }

  /// The battle with the opponent's [fleet] shown, once it is over.
  SeaBattleEntity revealOpponentFleet(FleetEntity fleet) => SeaBattleEntity(
    playerBoard: playerBoard,
    opponentBoard: opponentBoard.withFleet(fleet),
    turn: turn,
    lastShot: lastShot,
  );

  @override
  List<Object?> get props => [playerBoard, opponentBoard, turn, lastShot];
}

/// A shot fired by [shooter] at [cell] on the other side's board, with
/// the result the target's owner reported.
class ShotEntity extends Equatable {
  const ShotEntity({
    required this.shooter,
    required this.cell,
    required this.result,
    this.sunkShip,
  });

  final SeaBattleSide shooter;
  final BoardCoordinate cell;
  final ShotResult result;

  /// The ship this shot sank; set only when [result] is sunk.
  final ShipEntity? sunkShip;

  @override
  List<Object?> get props => [shooter, cell, result, sunkShip];
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
