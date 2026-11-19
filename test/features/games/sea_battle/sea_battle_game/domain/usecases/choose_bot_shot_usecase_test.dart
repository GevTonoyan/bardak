import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/choose_bot_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shots the bot needs to sink a random fleet.
int _shotsToWin(SeaBattleBotDifficulty difficulty, int seed) {
  final chooseBotShot = ChooseBotShotUseCase(random: Random(seed));
  var board = SeaBattleBoardEntity(fleet: FleetEntity.random(Random(seed)));
  var shots = 0;

  while (!board.isDefeated) {
    final cell = chooseBotShot(
      ChooseBotShotParams(board: board, difficulty: difficulty),
    );
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

void main() {
  for (final difficulty in SeaBattleBotDifficulty.values) {
    test('${difficulty.name} only fires at open cells until it wins', () {
      expect(_shotsToWin(difficulty, 7), lessThanOrEqualTo(100));
    });
  }

  test('harder bots need fewer shots to win', () {
    final easy = _averageShotsToWin(SeaBattleBotDifficulty.easy);
    final medium = _averageShotsToWin(SeaBattleBotDifficulty.medium);
    final hard = _averageShotsToWin(SeaBattleBotDifficulty.hard);

    expect(medium, lessThan(easy));
    expect(hard, lessThan(medium));
  });

  group('medium follows up a hit', () {
    const ship = ShipEntity(
      id: 0,
      length: 3,
      origin: BoardCoordinate(4, 4),
    );
    final board = SeaBattleBoardEntity(
      fleet: const FleetEntity().withShip(ship),
    );

    BoardCoordinate shotAfter(List<BoardCoordinate> cells, int seed) {
      var marked = board;
      for (final cell in cells) {
        (marked, _) = marked.shoot(cell);
      }
      return ChooseBotShotUseCase(random: Random(seed))(
        ChooseBotShotParams(
          board: marked,
          difficulty: .medium,
        ),
      );
    }

    test('next to a single hit', () {
      for (var seed = 0; seed < 10; seed++) {
        expect(
          shotAfter([const BoardCoordinate(4, 5)], seed),
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
          shotAfter(
            [const BoardCoordinate(4, 4), const BoardCoordinate(4, 5)],
            seed,
          ),
          isIn(const [BoardCoordinate(4, 3), BoardCoordinate(4, 6)]),
        );
      }
    });

    test('along a vertical line too', () {
      final vertical = SeaBattleBoardEntity(
        fleet: const FleetEntity().withShip(
          ship.copyWith(orientation: .vertical),
        ),
      );
      var marked = vertical;
      for (final cell in const [BoardCoordinate(5, 4), BoardCoordinate(6, 4)]) {
        (marked, _) = marked.shoot(cell);
      }

      expect(
        ChooseBotShotUseCase(random: Random(1))(
          ChooseBotShotParams(
            board: marked,
            difficulty: .medium,
          ),
        ),
        isIn(const [BoardCoordinate(4, 4), BoardCoordinate(7, 4)]),
      );
    });
  });
}
