import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_rules.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_result.dart';
import 'package:equatable/equatable.dart';

/// One side's board during a battle: their [fleet] and every cell the
/// other side has marked on it.
class SeaBattleBoardEntity extends Equatable {
  const SeaBattleBoardEntity({required this.fleet, this.marked = const {}});

  final FleetEntity fleet;

  /// Cells shot at, plus the cells around each sunk ship, which are marked
  /// automatically since no ship can be there.
  final Set<BoardCoordinate> marked;

  /// Whether [cell] can still be shot at.
  bool canShoot(BoardCoordinate cell) =>
      cell.isOnBoard && !marked.contains(cell);

  /// Every cell that can still be shot at.
  List<BoardCoordinate> get openCells => [
    for (var row = 0; row < SeaBattleRules.boardSize; row++)
      for (var column = 0; column < SeaBattleRules.boardSize; column++)
        if (canShoot(BoardCoordinate(row, column)))
          BoardCoordinate(row, column),
  ];

  /// Marked cells with part of a ship on them.
  Set<BoardCoordinate> get hitCells =>
      marked.where((cell) => fleet.shipAt(cell) != null).toSet();

  /// Marked cells with only water: misses and auto-marked cells.
  Set<BoardCoordinate> get missCells =>
      marked.where((cell) => fleet.shipAt(cell) == null).toSet();

  /// Whether every cell of [ship] has been hit.
  bool isSunk(ShipEntity ship) => ship.cells.every(marked.contains);

  List<ShipEntity> get sunkShips => fleet.ships.where(isSunk).toList();

  /// Hits on ships that are still afloat: where the shooter should aim
  /// next.
  Set<BoardCoordinate> get woundedCells =>
      hitCells.where((cell) => !isSunk(fleet.shipAt(cell)!)).toSet();

  /// Lengths of the ships still afloat. Known to the shooter too, since
  /// the fleet is the same for everyone.
  List<int> get afloatShipLengths {
    final lengths = [...SeaBattleRules.fleetShipLengths];
    for (final ship in sunkShips) {
      lengths.remove(ship.length);
    }
    return lengths;
  }

  /// Whether the whole fleet is sunk.
  bool get isDefeated => fleet.ships.every(isSunk);

  /// This board after a shot at [cell], and what the shot did. Sinking a
  /// ship also marks the cells around it.
  ///
  /// [cell] must be one that [canShoot].
  (SeaBattleBoardEntity, ShotResult) shoot(BoardCoordinate cell) {
    assert(canShoot(cell), 'Cell $cell was already marked');

    final ship = fleet.shipAt(cell);
    final marked = {...this.marked, cell};
    if (ship == null) return (_withMarked(marked), .miss);
    if (!ship.cells.every(marked.contains)) {
      return (_withMarked(marked), .hit);
    }

    return (
      _withMarked({...marked, ...ship.surroundingCells}),
      .sunk,
    );
  }

  SeaBattleBoardEntity _withMarked(Set<BoardCoordinate> marked) =>
      SeaBattleBoardEntity(fleet: fleet, marked: marked);

  @override
  List<Object?> get props => [fleet, marked];
}
