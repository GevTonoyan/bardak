import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleJoinRoomState extends Equatable {
  const SeaBattleJoinRoomState();

  @override
  List<Object?> get props => [];
}

/// Joining the room from an invite link.
final class SeaBattleJoinRoomJoining extends SeaBattleJoinRoomState {
  const SeaBattleJoinRoomJoining();
}

/// In the room as its guest, ready to place ships.
final class SeaBattleJoinRoomJoined extends SeaBattleJoinRoomState {
  const SeaBattleJoinRoomJoined(this.room);

  final SeaBattleRoomEntity room;

  @override
  List<Object?> get props => [room];
}

/// Joining failed for [reason].
final class SeaBattleJoinRoomFailure extends SeaBattleJoinRoomState {
  const SeaBattleJoinRoomFailure(this.reason);

  final SeaBattleRoomFailure reason;

  @override
  List<Object?> get props => [reason];
}
