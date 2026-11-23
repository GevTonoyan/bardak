import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:equatable/equatable.dart';

class ShipPlacementState extends Equatable {
  const ShipPlacementState({required this.fleet});

  final FleetEntity fleet;

  @override
  List<Object?> get props => [fleet];
}
