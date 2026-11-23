import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/data/data_sources/sea_battle_opponent_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';

SeaBattleOpponentLocalDataSourceImpl _bot(
  SeaBattleBotDifficulty difficulty, {
  int seed = 1,
}) => SeaBattleOpponentLocalDataSourceImpl(
  difficulty: difficulty,
  random: Random(seed),
);

/// Shots the bot needs to sink a random fleet, seeing only the results.
int _shotsToWin(SeaBattleBotDifficulty difficulty, int seed) {
  final bot = _bot(difficulty, seed: seed);
  var board = SeaBattleBoardEntity(fleet: FleetEntity.random(Random(seed)));
  var shots = 0;

  while (!board.isDefeated) {
    final cell = bot.chooseShot(board.withoutFleet);
    expect(board.canShoot(cell), isTrue, reason: 'never repeats a cell');
    (board, _) = board.shoot(cell);
    shots++;
  }
  return shots;
}

double _averageShotsToWin(SeaBattleBotDifficulty difficulty) {
  const games = 12;
  var total = 0;
  for (var seed = 0; seed < games; seed++) {
    total += _shotsToWin(difficulty, seed);
  }
  return total / games;
}

/// A board with reported hits at [cells] on a ship still afloat.
SeaBattleBoardEntity _hitsAt(List<BoardCoordinate> cells) {
  var board = const SeaBattleBoardEntity();
  for (final cell in cells) {
    board = board.record(cell, .hit);
  }
  return board;
}

void main() {
  group('answering the player', () {
    test('answers from its own fleet and keeps track of it', () async {
      final bot = _bot(.medium);
      final fleet = await bot.getOpponentFleet();
      final boat = fleet.ships.firstWhere((ship) => ship.length == 1);

      expect(fleet.isComplete, isTrue);
      expect(
        await bot.answerPlayerShot(boat.origin),
        ShotEntity(
          shooter: .player,
          cell: boat.origin,
          result: .sunk,
          sunkShip: boat,
        ),
      );
    });

    test('reports a sunk ship only on its last cell', () async {
      final bot = _bot(.medium);
      final fleet = await bot.getOpponentFleet();
      final ship = fleet.ships.firstWhere((ship) => ship.length == 2);

      final first = await bot.answerPlayerShot(ship.cells.first);
      final last = await bot.answerPlayerShot(ship.cells.last);

      expect(first.result, ShotResult.hit);
      expect(first.sunkShip, isNull);
      expect(last.result, ShotResult.sunk);
      expect(last.sunkShip, ship);
    });
  });

  group('firing back', () {
    for (final difficulty in SeaBattleBotDifficulty.values) {
      test('${difficulty.name} only fires at open cells until it wins', () {
        expect(_shotsToWin(difficulty, 7), lessThanOrEqualTo(100));
      });
    }

    test('harder bots need fewer shots to win', () {
      final easy = _averageShotsToWin(.easy);
      final medium = _averageShotsToWin(.medium);
      final hard = _averageShotsToWin(.hard);

      expect(medium, lessThan(easy));
      expect(hard, lessThan(medium));
    });

    test('pauses before each shot', () async {
      final stopwatch = Stopwatch()..start();
      await _bot(.medium).getOpponentShot(const SeaBattleBoardEntity());

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(650));
    });
  });

  group('medium follows up a hit', () {
    test('next to a single hit', () {
      for (var seed = 0; seed < 10; seed++) {
        expect(
          _bot(.medium, seed: seed).chooseShot(
            _hitsAt([const BoardCoordinate(4, 5)]),
          ),
          isIn(const [
            BoardCoordinate(3, 5),
            BoardCoordinate(5, 5),
            BoardCoordinate(4, 4),
            BoardCoordinate(4, 6),
          ]),
        );
      }
    });

    test('at the ends of a line of hits', () {
      for (var seed = 0; seed < 10; seed++) {
        expect(
          _bot(.medium, seed: seed).chooseShot(
            _hitsAt([const BoardCoordinate(4, 4), const BoardCoordinate(4, 5)]),
          ),
          isIn(const [BoardCoordinate(4, 3), BoardCoordinate(4, 6)]),
        );
      }
    });

    test('along a vertical line too', () {
      expect(
        _bot(.medium).chooseShot(
          _hitsAt([const BoardCoordinate(5, 4), const BoardCoordinate(6, 4)]),
        ),
        isIn(const [BoardCoordinate(4, 4), BoardCoordinate(7, 4)]),
      );
    });

    test('and ignores hits on ships already sunk', () {
      const sunk = ShipEntity(id: 6, length: 1, origin: BoardCoordinate(0, 0));
      final board = const SeaBattleBoardEntity().record(
        sunk.origin,
        .sunk,
        sunkShip: sunk,
      );

      expect(board.canShoot(_bot(.medium).chooseShot(board)), isTrue);
      expect(board.woundedCells, isEmpty);
    });
  });
}
