import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';

/// Picks the cell the bot fires at next on the player's board.
///
/// The bot plays fair: it only uses what a human would see — which cells
/// are marked, which of them are hits, which ships are sunk — never where
/// the player's ships are.
///
/// - Easy shoots at random and follows up a hit only now and then.
/// - Medium shoots at random until it hits, then finishes that ship off.
/// - Hard counts, for every open cell, how many ways the remaining ships
///   could cover it, and fires at the likeliest one.
class ChooseBotShotUseCase {
  ChooseBotShotUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// How often the easy bot follows up a hit instead of shooting at
  /// random.
  static const _easyFollowUpChance = 0.4;

  BoardCoordinate call(ChooseBotShotParams params) {
    final board = params.board;

    return switch (params.difficulty) {
      .easy =>
        _random.nextDouble() < _easyFollowUpChance
            ? _followUp(board) ?? _randomCell(board)
            : _randomCell(board),
      .medium => _followUp(board) ?? _randomCell(board),
      .hard => _likeliestCell(board),
    };
  }

  BoardCoordinate _randomCell(SeaBattleBoardEntity board) {
    final cells = board.openCells;
    return cells[_random.nextInt(cells.length)];
  }

  /// A cell next to the hits on a ship still afloat, or null when there
  /// are none. Two or more hits show the ship's direction, so only the
  /// ends of that line are tried.
  BoardCoordinate? _followUp(SeaBattleBoardEntity board) {
    final wounded = board.woundedCells.toList();
    if (wounded.isEmpty) return null;

    List<BoardCoordinate> candidates;
    if (wounded.length > 1) {
      final isHorizontal = wounded.every((c) => c.row == wounded.first.row);
      final sorted = [...wounded]
        ..sort(
          (a, b) => isHorizontal ? a.column - b.column : a.row - b.row,
        );
      candidates = isHorizontal
          ? [sorted.first.shift(columns: -1), sorted.last.shift(columns: 1)]
          : [sorted.first.shift(rows: -1), sorted.last.shift(rows: 1)];
    } else {
      final hit = wounded.single;
      candidates = [
        hit.shift(rows: -1),
        hit.shift(rows: 1),
        hit.shift(columns: -1),
        hit.shift(columns: 1),
      ];
    }

    final open = candidates.where(board.canShoot).toList();
    if (open.isEmpty) return null;
    return open[_random.nextInt(open.length)];
  }

  /// The open cell covered by the most possible positions of the ships
  /// still afloat. While a ship is wounded, only positions through its
  /// hits count, so the bot finishes it first.
  BoardCoordinate _likeliestCell(SeaBattleBoardEntity board) {
    final wounded = board.woundedCells;
    final scores = <BoardCoordinate, int>{};

    for (final length in board.afloatShipLengths) {
      for (final ship in _positions(length)) {
        final cells = ship.cells;
        // A ship can only lie on open cells and on hits of a ship that is
        // still afloat.
        if (!cells.every((c) => board.canShoot(c) || wounded.contains(c))) {
          continue;
        }
        final hitsCovered = cells.where(wounded.contains).length;
        if (wounded.isNotEmpty && hitsCovered == 0) continue;

        for (final cell in cells.where(board.canShoot)) {
          scores[cell] = (scores[cell] ?? 0) + 1 + hitsCovered * 10;
        }
      }
    }

    if (scores.isEmpty) return _randomCell(board);

    final best = scores.values.reduce(max);
    final likeliest = [
      for (final MapEntry(key: cell, value: score) in scores.entries)
        if (score == best) cell,
    ];
    return likeliest[_random.nextInt(likeliest.length)];
  }

  /// Every position a ship of [length] could take on an empty board.
  Iterable<ShipEntity> _positions(int length) sync* {
    for (final orientation in ShipOrientation.values) {
      for (var row = 0; row < BoardCoordinate.boardSize; row++) {
        for (var column = 0; column < BoardCoordinate.boardSize; column++) {
          final ship = ShipEntity(
            id: 0,
            length: length,
            origin: BoardCoordinate(row, column),
            orientation: orientation,
          );
          if (ship.isOnBoard) yield ship;
        }
      }
    }
  }
}

class ChooseBotShotParams {
  const ChooseBotShotParams({required this.board, required this.difficulty});

  /// The player's board, as the bot fires at it.
  final SeaBattleBoardEntity board;
  final SeaBattleBotDifficulty difficulty;
}
