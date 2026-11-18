import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ShipPlacementEvent extends Equatable {
  const ShipPlacementEvent();

  @override
  List<Object?> get props => [];
}

/// Places [ship] on the board, or moves it if it is already there.
/// Ignored when the position breaks the rules.
class PlaceShip extends ShipPlacementEvent {
  const PlaceShip(this.ship);

  final ShipEntity ship;

  @override
  List<Object?> get props => [ship];
}

/// Rotates a placed ship around its origin. Ignored when the rotated ship
/// would not fit.
class RotateShip extends ShipPlacementEvent {
  const RotateShip(this.shipId);

  final int shipId;

  @override
  List<Object?> get props => [shipId];
}

/// Takes a placed ship off the board, back to the tray.
class RemoveShip extends ShipPlacementEvent {
  const RemoveShip(this.shipId);

  final int shipId;

  @override
  List<Object?> get props => [shipId];
}

/// Places the whole fleet at random positions.
class ShuffleShips extends ShipPlacementEvent {
  const ShuffleShips();
}

/// Takes every ship off the board.
class ClearShips extends ShipPlacementEvent {
  const ClearShips();
}
