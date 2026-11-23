import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleWaitingRoomState extends Equatable {
  const SeaBattleWaitingRoomState();

  @override
  List<Object?> get props => [];
}

/// Creating the room.
final class SeaBattleWaitingRoomCreating extends SeaBattleWaitingRoomState {
  const SeaBattleWaitingRoomCreating();
}

/// The room could not be created or followed, e.g. no connection.
final class SeaBattleWaitingRoomFailure extends SeaBattleWaitingRoomState {
  const SeaBattleWaitingRoomFailure();
}

/// The room is open and shared; once [room] has an opponent the guest is
/// in.
final class SeaBattleWaitingRoomWaiting extends SeaBattleWaitingRoomState {
  const SeaBattleWaitingRoomWaiting(this.room);

  /// The room as last seen.
  final SeaBattleRoomEntity room;

  @override
  List<Object?> get props => [room];
}

/// This player is leaving: the room, if there is one, is being closed.
/// A room created or deleted meanwhile is ignored.
final class SeaBattleWaitingRoomLeaving extends SeaBattleWaitingRoomState {
  const SeaBattleWaitingRoomLeaving();
}

/// The room is gone without this player leaving it, e.g. it expired.
final class SeaBattleWaitingRoomClosed extends SeaBattleWaitingRoomState {
  const SeaBattleWaitingRoomClosed();
}

/// This player left, so the screen can close.
final class SeaBattleWaitingRoomLeft extends SeaBattleWaitingRoomState {
  const SeaBattleWaitingRoomLeft();
}
