import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleOnlinePlacementEvent extends Equatable {
  const SeaBattleOnlinePlacementEvent();

  @override
  List<Object?> get props => [];
}

/// Follows the room: the other player getting ready, the battle starting,
/// or the room closing.
final class WatchRoom extends SeaBattleOnlinePlacementEvent {
  const WatchRoom();
}

/// Tells the room this player is ready with [fleet]. Sent again to retry.
final class MarkReady extends SeaBattleOnlinePlacementEvent {
  const MarkReady(this.fleet);

  final FleetEntity fleet;

  @override
  List<Object?> get props => [fleet];
}

/// Starts the battle once both players are ready. Only the host sends it.
final class StartBattle extends SeaBattleOnlinePlacementEvent {
  const StartBattle();
}

/// Leaves the room, closing it for both players.
final class LeaveRoom extends SeaBattleOnlinePlacementEvent {
  const LeaveRoom();
}
