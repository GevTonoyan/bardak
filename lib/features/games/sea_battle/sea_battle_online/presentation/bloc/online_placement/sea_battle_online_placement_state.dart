import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleOnlinePlacementState extends Equatable {
  const SeaBattleOnlinePlacementState();

  @override
  List<Object?> get props => [];
}

/// Placing ships.
final class SeaBattleOnlinePlacementPlacing
    extends SeaBattleOnlinePlacementState {
  const SeaBattleOnlinePlacementPlacing();
}

/// Ready with [fleet], waiting for the other player.
final class SeaBattleOnlinePlacementWaiting
    extends SeaBattleOnlinePlacementState {
  const SeaBattleOnlinePlacementWaiting(this.fleet);

  final FleetEntity fleet;

  @override
  List<Object?> get props => [fleet];
}

/// The battle has started in [room], which says who fires first.
final class SeaBattleOnlinePlacementStarted
    extends SeaBattleOnlinePlacementState {
  const SeaBattleOnlinePlacementStarted({
    required this.room,
    required this.fleet,
  });

  final SeaBattleRoomEntity room;
  final FleetEntity fleet;

  @override
  List<Object?> get props => [room, fleet];
}

/// Telling the room this player is ready failed; [fleet] is kept to retry.
final class SeaBattleOnlinePlacementFailure
    extends SeaBattleOnlinePlacementState {
  const SeaBattleOnlinePlacementFailure(this.fleet);

  final FleetEntity fleet;

  @override
  List<Object?> get props => [fleet];
}

/// The room is gone, e.g. the other player left.
final class SeaBattleOnlinePlacementClosed
    extends SeaBattleOnlinePlacementState {
  const SeaBattleOnlinePlacementClosed();
}

/// The player left the room.
final class SeaBattleOnlinePlacementLeft extends SeaBattleOnlinePlacementState {
  const SeaBattleOnlinePlacementLeft();
}
