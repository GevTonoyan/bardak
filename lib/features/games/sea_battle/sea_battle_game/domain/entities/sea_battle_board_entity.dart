import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:equatable/equatable.dart';

/// One side's board during a battle: every result of the shots fired at
/// it, and its [fleet] when that is known.
///
/// The player knows their own fleet; the opponent's stays hidden (null)
/// until the battle is over, so that board is built only from the results
/// the opponent reports. Only a board with a known fleet can [answer] a
/// shot.
class SeaBattleBoardEntity extends Equatable {
  const SeaBattleBoardEntity({
    this.fleet,
    this.marked = const {},
    this.hitCells = const {},
    this.sunkShips = const [],
    this.shotCount = 0,
  });

  /// Where the ships are, or null while they are hidden from the shooter.
  final FleetEntity? fleet;

  /// Cells shot at, plus the cells around each sunk ship, which are marked
  /// automatically since no ship can be there.
  final Set<BoardCoordinate> marked;

  /// Marked cells with part of a ship on them.
  final Set<BoardCoordinate> hitCells;

  /// Ships sunk so far, revealed as each one goes down.
  final List<ShipEntity> sunkShips;

  /// Shots actually fired at this board; cells marked automatically around
  /// sunk ships do not count.
  final int shotCount;

  /// Whether [cell] can still be shot at.
  bool canShoot(BoardCoordinate cell) =>
      cell.isOnBoard && !marked.contains(cell);

  /// Every cell that can still be shot at.
  List<BoardCoordinate> get openCells => [
    for (var row = 0; row < BoardCoordinate.boardSize; row++)
      for (var column = 0; column < BoardCoordinate.boardSize; column++)
        if (canShoot(BoardCoordinate(row, column)))
          BoardCoordinate(row, column),
  ];

  /// Marked cells with only water: misses and auto-marked cells.
  Set<BoardCoordinate> get missCells => marked.difference(hitCells);

  /// Hits on ships that are still afloat: where the shooter should aim
  /// next.
  Set<BoardCoordinate> get woundedCells => hitCells.difference({
    for (final ship in sunkShips) ...ship.cells,
  });

  /// Lengths of the ships still afloat. Known to the shooter too, since
  /// the fleet is the same for everyone.
  List<int> get afloatShipLengths {
    final lengths = [...FleetEntity.shipLengths];
    for (final ship in sunkShips) {
      lengths.remove(ship.length);
    }
    return lengths;
  }

  /// Share of the shots at this board that struck a ship, from 0 to 1.
  double get hitRate => shotCount == 0 ? 0 : hitCells.length / shotCount;

  /// Whether the whole fleet is sunk.
  bool get isDefeated => sunkShips.length == FleetEntity.shipCount;

  /// What a shot at [cell] does, and the ship it sinks if it does. Worked
  /// out from the [fleet], so only the board's owner can answer.
  ///
  /// [cell] must be one that [canShoot].
  (ShotResult, ShipEntity?) answer(BoardCoordinate cell) {
    final fleet = this.fleet;
    assert(fleet != null, 'Only a board with a known fleet can answer');
    assert(canShoot(cell), 'Cell $cell was already marked');

    final ship = fleet!.shipAt(cell);
    if (ship == null) return (.miss, null);

    final isLastCell = ship.cells.every(
      (shipCell) => shipCell == cell || hitCells.contains(shipCell),
    );
    return isLastCell ? (.sunk, ship) : (.hit, null);
  }

  /// This board after a shot at [cell] with the given [result]. Sinking
  /// [sunkShip] also marks the cells around it.
  SeaBattleBoardEntity record(
    BoardCoordinate cell,
    ShotResult result, {
    ShipEntity? sunkShip,
  }) {
    assert(
      (result == .sunk) == (sunkShip != null),
      'A sunk ship is reported exactly when the result is sunk',
    );

    return SeaBattleBoardEntity(
      fleet: fleet,
      marked: {...marked, cell, ...?sunkShip?.surroundingCells},
      hitCells: result.isHit ? {...hitCells, cell} : hitCells,
      sunkShips: [...sunkShips, ?sunkShip],
      shotCount: shotCount + 1,
    );
  }

  /// This board after a shot at [cell], answered from its own [fleet].
  (SeaBattleBoardEntity, ShotResult) shoot(BoardCoordinate cell) {
    final (result, sunkShip) = answer(cell);
    return (record(cell, result, sunkShip: sunkShip), result);
  }

  /// This board with its [fleet] revealed, once the battle is over.
  SeaBattleBoardEntity withFleet(FleetEntity fleet) => SeaBattleBoardEntity(
    fleet: fleet,
    marked: marked,
    hitCells: hitCells,
    sunkShips: sunkShips,
    shotCount: shotCount,
  );

  /// This board as the shooter sees it: the results, but not the fleet.
  SeaBattleBoardEntity get withoutFleet => SeaBattleBoardEntity(
    marked: marked,
    hitCells: hitCells,
    sunkShips: sunkShips,
    shotCount: shotCount,
  );

  @override
  List<Object?> get props => [fleet, marked, hitCells, sunkShips, shotCount];
}

/// What a shot did.
enum ShotResult {
  /// Only water; the turn passes to the other side.
  miss,

  /// Struck a ship that is still afloat; the shooter fires again.
  hit,

  /// Struck the last cell of a ship; the shooter fires again.
  sunk;

  /// Whether the shot struck a ship, so the shooter keeps the turn.
  bool get isHit => this != miss;
}
