import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:flutter_test/flutter_test.dart';

SeaBattleBoardEntity _boardWithBoatAt(int row, int column) =>
    SeaBattleBoardEntity(
      fleet: const FleetEntity().withShip(
        ShipEntity(id: 0, length: 1, origin: BoardCoordinate(row, column)),
      ),
    );

final _battle = SeaBattleEntity(
  playerBoard: _boardWithBoatAt(0, 0),
  opponentBoard: _boardWithBoatAt(5, 5),
  turn: .player,
);

void main() {
  test('a miss passes the turn and lands on the opponent board', () {
    final battle = _battle.fire(const BoardCoordinate(1, 1));
    final result = battle.lastShot!.result;

    expect(result, ShotResult.miss);
    expect(battle.turn, SeaBattleSide.opponent);
    expect(battle.opponentBoard.missCells, {const BoardCoordinate(1, 1)});
    expect(battle.playerBoard, _battle.playerBoard);
  });

  test('the opponent fires at the player board', () {
    final missed = _battle.fire(const BoardCoordinate(1, 1));
    final battle = missed.fire(const BoardCoordinate(9, 9));
    final result = battle.lastShot!.result;

    expect(result, ShotResult.miss);
    expect(battle.turn, SeaBattleSide.player);
    expect(battle.playerBoard.missCells, {const BoardCoordinate(9, 9)});
  });

  test('a hit keeps the turn', () {
    final battle = SeaBattleEntity(
      playerBoard: _battle.playerBoard,
      opponentBoard: SeaBattleBoardEntity(
        fleet: const FleetEntity().withShip(
          const ShipEntity(id: 0, length: 2, origin: BoardCoordinate(5, 5)),
        ),
      ),
      turn: .player,
    );

    final next = battle.fire(const BoardCoordinate(5, 5));
    final result = next.lastShot!.result;

    expect(result, ShotResult.hit);
    expect(next.turn, SeaBattleSide.player);
  });

  test('sinking the last ship wins and stops all firing', () {
    final battle = _battle.fire(const BoardCoordinate(5, 5));
    final result = battle.lastShot!.result;

    expect(result, ShotResult.sunk);
    expect(battle.winner, SeaBattleSide.player);
    expect(battle.isOver, isTrue);
    expect(
      battle.canFire(.player, const BoardCoordinate(1, 1)),
      isFalse,
    );
  });

  test('canFire only for the side whose turn it is, at open cells', () {
    const open = BoardCoordinate(2, 2);

    expect(_battle.canFire(.player, open), isTrue);
    expect(_battle.canFire(.opponent, open), isFalse);

    final battle = _battle.fire(open);
    final back = battle.fire(const BoardCoordinate(9, 9));
    expect(back.canFire(.player, open), isFalse);
  });

  test('targetOf is the other side board', () {
    expect(_battle.targetOf(.player), _battle.opponentBoard);
    expect(_battle.targetOf(.opponent), _battle.playerBoard);
  });

  test('SeaBattleSide.other and ShotResult.isHit', () {
    expect(SeaBattleSide.player.other, SeaBattleSide.opponent);
    expect(SeaBattleSide.opponent.other, SeaBattleSide.player);
    expect(ShotResult.miss.isHit, isFalse);
    expect(ShotResult.hit.isHit, isTrue);
    expect(ShotResult.sunk.isHit, isTrue);
  });
}
