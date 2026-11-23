import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/domain/usecases/generate_random_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lets a player arrange their fleet before the battle. Shared by every
/// mode; the screen decides what happens once the fleet is complete.
class ShipPlacementBloc extends Bloc<ShipPlacementEvent, ShipPlacementState> {
  ShipPlacementBloc({required this._generateRandomFleetUseCase})
    : super(const ShipPlacementState(fleet: FleetEntity())) {
    on<PlaceShip>(_onPlaceShip);
    on<RotateShip>(_onRotateShip);
    on<RemoveShip>(_onRemoveShip);
    on<ShuffleShips>(_onShuffleShips);
  }

  final GenerateRandomFleetUseCase _generateRandomFleetUseCase;

  void _onPlaceShip(PlaceShip event, Emitter<ShipPlacementState> emit) {
    final fleet = state.fleet;
    if (!fleet.canPlace(event.ship)) return;

    emit(ShipPlacementState(fleet: fleet.withShip(event.ship)));
  }

  void _onRotateShip(RotateShip event, Emitter<ShipPlacementState> emit) {
    final fleet = state.fleet;
    final ship = fleet.ships.where((ship) => ship.id == event.shipId);
    if (ship.isEmpty) return;

    // Turning in place first; where that does not fit, the other way or
    // around another of its cells.
    final rotated = ship.first.rotations.where(fleet.canPlace);
    if (rotated.isEmpty) return;

    emit(ShipPlacementState(fleet: fleet.withShip(rotated.first)));
  }

  void _onRemoveShip(RemoveShip event, Emitter<ShipPlacementState> emit) {
    emit(ShipPlacementState(fleet: state.fleet.withoutShip(event.shipId)));
  }

  void _onShuffleShips(ShuffleShips event, Emitter<ShipPlacementState> emit) {
    emit(ShipPlacementState(fleet: _generateRandomFleetUseCase()));
  }
}
