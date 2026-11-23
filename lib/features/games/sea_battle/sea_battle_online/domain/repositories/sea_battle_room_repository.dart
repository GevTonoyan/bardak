import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';

/// Every method fails with a [SeaBattleRoomException]; a lost connection
/// is [SeaBattleRoomFailure.connection].
abstract interface class SeaBattleRoomRepository {
  /// Creates a room with a new code, with this player as its host.
  Future<SeaBattleRoomEntity> createRoom();

  /// Joins the room with [code] as its guest.
  ///
  /// Fails with [SeaBattleRoomFailure.notFound] when there is no such
  /// room, or [SeaBattleRoomFailure.full] when its seat is taken.
  Future<SeaBattleRoomEntity> joinRoom(String code);

  /// The room with [code] whenever it changes; null once it is gone.
  Stream<SeaBattleRoomEntity?> watchRoom(String code);

  /// Leaves the room with [code], closing it for both players.
  Future<void> leaveRoom(String code);

  /// Marks this player's fleet in the room with [code] as placed.
  Future<void> markReady(String code);

  /// Picks who fires first and starts the battle in the room with [code].
  /// Only the host calls it, once both players are ready.
  Future<void> startBattle(String code);
}
