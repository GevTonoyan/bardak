import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:equatable/equatable.dart';

/// The ships one player has placed on their board.
///
/// Every player gets the same fleet, [shipLengths]. Ships may never touch,
/// not even diagonally. The fleet may be partial while the player is still
/// placing ships; [isComplete] tells when every ship is on the board.
class FleetEntity extends Equatable {
  const FleetEntity({this.ships = const []});

  /// Places the full fleet at random positions, following the rules.
  factory FleetEntity.random(Random random) {
    // The classic fleet nearly always fits on the first try; restarting
    // the rare dead end is simpler than backtracking.
    while (true) {
      final fleet = _tryPlaceRandomly(random);
      if (fleet != null) return fleet;
    }
  }

  /// Length of every ship in the fleet, largest first. A ship's index in
  /// this list is its id.
  static const shipLengths = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];

  /// Number of ships in a full fleet.
  static int get shipCount => shipLengths.length;

  static const _maxAttemptsPerShip = 200;

  final List<ShipEntity> ships;

  /// Whether every ship of the fleet is on the board.
  bool get isComplete => ships.length == shipCount;

  /// Ids of the fleet ships not placed yet.
  List<int> get unplacedShipIds => [
    for (var id = 0; id < shipCount; id++)
      if (!ships.any((ship) => ship.id == id)) id,
  ];

  /// The ship occupying [cell], if any.
  ShipEntity? shipAt(BoardCoordinate cell) {
    for (final ship in ships) {
      if (ship.occupies(cell)) return ship;
    }
    return null;
  }

  /// Whether [ship] can be placed: fully on the board and not touching any
  /// other ship. A ship already in the fleet with the same id is ignored,
  /// so this also validates moving or rotating it.
  bool canPlace(ShipEntity ship) {
    if (!ship.isOnBoard) return false;

    final area = ship.area;
    return ships
        .where((other) => other.id != ship.id)
        .every((other) => !other.cells.any(area.contains));
  }

  /// This fleet with [ship] added, or replacing the ship with its id.
  FleetEntity withShip(ShipEntity ship) => FleetEntity(
    ships: [...ships.where((other) => other.id != ship.id), ship],
  );

  /// This fleet without the ship with [shipId].
  FleetEntity withoutShip(int shipId) => FleetEntity(
    ships: ships.where((ship) => ship.id != shipId).toList(),
  );

  static FleetEntity? _tryPlaceRandomly(Random random) {
    var fleet = const FleetEntity();

    for (var id = 0; id < shipCount; id++) {
      final length = shipLengths[id];
      ShipEntity? placed;

      for (var attempt = 0; attempt < _maxAttemptsPerShip; attempt++) {
        final candidate = ShipEntity(
          id: id,
          length: length,
          origin: BoardCoordinate(
            random.nextInt(BoardCoordinate.boardSize),
            random.nextInt(BoardCoordinate.boardSize),
          ),
          orientation: random.nextBool()
              ? ShipOrientation.horizontal
              : ShipOrientation.vertical,
        );
        if (fleet.canPlace(candidate)) {
          placed = candidate;
          break;
        }
      }

      if (placed == null) return null;
      fleet = fleet.withShip(placed);
    }

    return fleet;
  }

  @override
  List<Object?> get props => [ships];
}
