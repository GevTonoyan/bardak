import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:flutter_test/flutter_test.dart';

final _playerFleet = FleetEntity.random(Random(1));
final _opponentFleet = FleetEntity.random(Random(2));

final _battle = SeaBattleEntity(
  playerBoard: SeaBattleBoardEntity(fleet: _playerFleet),
  opponentBoard: const SeaBattleBoardEntity(),
  turn: .player,
);

/// A cell with no ship on [fleet].
BoardCoordinate _water(FleetEntity fleet) => [
  for (var row = 0; row < BoardCoordinate.boardSize; row++)
    for (var column = 0; column < BoardCoordinate.boardSize; column++)
      BoardCoordinate(row, column),
].firstWhere((cell) => fleet.shipAt(cell) == null);

ShotEntity _playerShot(
  BoardCoordinate cell,
  ShotResult result, {
  ShipEntity? sunkShip,
}) => ShotEntity(
  shooter: .player,
  cell: cell,
  result: result,
  sunkShip: sunkShip,
);

void main() {
  test('a reported miss lands on the opponent board and passes the turn', () {
    const cell = BoardCoordinate(1, 1);
    final battle = _battle.record(_playerShot(cell, .miss));

    expect(battle.turn, SeaBattleSide.opponent);
    expect(battle.opponentBoard.missCells, {cell});
    expect(battle.playerBoard, _battle.playerBoard);
    expect(battle.lastShot, _playerShot(cell, .miss));
  });

  test('a reported hit keeps the turn', () {
    final battle = _battle.record(
      _playerShot(const BoardCoordinate(3, 3), .hit),
    );

    expect(battle.turn, SeaBattleSide.player);
    expect(battle.opponentBoard.hitCells, {const BoardCoordinate(3, 3)});
  });

  test("the opponent's shot is answered from the player's fleet", () {
    final missed = _battle.record(
      _playerShot(const BoardCoordinate(1, 1), .miss),
    );
    final ship = _playerFleet.ships.firstWhere((ship) => ship.length == 1);

    final shot = missed.answerOpponentShot(ship.origin);
    final battle = missed.record(shot);

    expect(
      shot,
      ShotEntity(
        shooter: .opponent,
        cell: ship.origin,
        result: .sunk,
        sunkShip: ship,
      ),
    );
    expect(battle.playerBoard.sunkShips, [ship]);
    expect(battle.turn, SeaBattleSide.opponent);
  });

  test('a water shot by the opponent is answered as a miss', () {
    final missed = _battle.record(
      _playerShot(const BoardCoordinate(1, 1), .miss),
    );

    expect(
      missed.answerOpponentShot(_water(_playerFleet)).result,
      ShotResult.miss,
    );
  });

  test('sinking the whole hidden fleet wins and stops all firing', () {
    var battle = _battle;
    for (final ship in _opponentFleet.ships) {
      for (final cell in ship.cells) {
        final isLast = cell == ship.cells.last;
        battle = battle.record(
          _playerShot(
            cell,
            isLast ? .sunk : .hit,
            sunkShip: isLast ? ship : null,
          ),
        );
      }
    }

    expect(battle.winner, SeaBattleSide.player);
    expect(battle.isOver, isTrue);
    expect(battle.canFire(.player, _water(_opponentFleet)), isFalse);
  });

  test('canFire only for the side whose turn it is, at open cells', () {
    const open = BoardCoordinate(2, 2);

    expect(_battle.canFire(.player, open), isTrue);
    expect(_battle.canFire(.opponent, open), isFalse);

    final battle = _battle.record(_playerShot(open, .miss));
    expect(battle.canFire(.player, const BoardCoordinate(5, 5)), isFalse);
  });

  test('revealOpponentFleet shows the fleet and keeps the results', () {
    final battle = _battle.record(
      _playerShot(const BoardCoordinate(1, 1), .miss),
    );

    final revealed = battle.revealOpponentFleet(_opponentFleet);

    expect(revealed.opponentBoard.fleet, _opponentFleet);
    expect(revealed.opponentBoard.missCells, battle.opponentBoard.missCells);
    expect(revealed.turn, battle.turn);
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
