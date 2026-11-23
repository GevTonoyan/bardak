import 'package:equatable/equatable.dart';

sealed class SeaBattleJoinRoomEvent extends Equatable {
  const SeaBattleJoinRoomEvent();

  @override
  List<Object?> get props => [];
}

/// Joins the room with [code] as its guest. Sent again to retry.
final class JoinRoom extends SeaBattleJoinRoomEvent {
  const JoinRoom(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}
