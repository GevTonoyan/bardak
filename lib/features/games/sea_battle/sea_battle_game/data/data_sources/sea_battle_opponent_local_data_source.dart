import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:flutter/foundation.dart';

/// The bot opponent, playing on the device.
abstract interface class SeaBattleOpponentLocalDataSource {
  /// What the player's shot at [cell] did on the bot's board.
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell);

  /// The bot's next shot at [playerBoard], which comes without the
  /// player's fleet.
  Future<BoardCoordinate> getOpponentShot(SeaBattleBoardEntity playerBoard);

  /// Where the bot's ships are.
  Future<FleetEntity> getOpponentFleet();
}

/// A bot with a random fleet that fires back after a short pause.
///
/// It plays fair: it aims using only what a human would see — which cells
/// are marked, which of them are hits, which ships are sunk.
///
/// - Easy shoots at random and follows up a hit only now and then.
/// - Medium shoots at random until it hits, then finishes that ship off.
/// - Hard counts, for every open cell, how many ways the remaining ships
///   could cover it, and fires at the likeliest one.
class SeaBattleOpponentLocalDataSourceImpl
    implements SeaBattleOpponentLocalDataSource {
  SeaBattleOpponentLocalDataSourceImpl({
    required this._difficulty,
    Random? random,
  }) : _random = random ?? Random() {
    _board = SeaBattleBoardEntity(fleet: FleetEntity.random(_random));
  }

  final SeaBattleBotDifficulty _difficulty;
  final Random _random;

  /// The bot's own board: its fleet and the player's shots at it.
  late SeaBattleBoardEntity _board;

  /// Pause before each bot shot, so the player can follow it.
  static const _shotDelay = Duration(milliseconds: 700);

  /// How often the easy bot follows up a hit instead of shooting at
  /// random.
  static const _easyFollowUpChance = 0.4;

  @override
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell) async {
    final (result, sunkShip) = _board.answer(cell);
    _board = _board.record(cell, result, sunkShip: sunkShip);

    return ShotEntity(
      shooter: .player,
      cell: cell,
      result: result,
      sunkShip: sunkShip,
    );
  }

  @override
  Future<BoardCoordinate> getOpponentShot(
    SeaBattleBoardEntity playerBoard,
  ) async {
    await Future<void>.delayed(_shotDelay);
    return chooseShot(playerBoard);
  }

  @override
  Future<FleetEntity> getOpponentFleet() async => _board.fleet!;

  /// The cell the bot fires at on [board], without the pause.
  @visibleForTesting
  BoardCoordinate chooseShot(SeaBattleBoardEntity board) {
    return switch (_difficulty) {
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
