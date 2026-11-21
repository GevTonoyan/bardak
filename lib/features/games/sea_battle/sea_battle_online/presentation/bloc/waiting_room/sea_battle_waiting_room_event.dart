import 'package:equatable/equatable.dart';

sealed class SeaBattleWaitingRoomEvent extends Equatable {
  const SeaBattleWaitingRoomEvent();

  @override
  List<Object?> get props => [];
}

/// Creates a room with this player as its host, then follows it until the
/// guest joins or the room is gone. Sent again to retry after a failure.
final class CreateRoom extends SeaBattleWaitingRoomEvent {
  const CreateRoom();
}

/// Leaves the room, closing it.
final class LeaveRoom extends SeaBattleWaitingRoomEvent {
  const LeaveRoom();
}
