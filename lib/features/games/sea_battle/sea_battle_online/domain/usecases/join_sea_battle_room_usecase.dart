import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Joins a room by its code, as its guest.
///
/// Throws a [SeaBattleRoomException] when the room is not found, full, or
/// cannot be reached.
class JoinSeaBattleRoomUseCase {
  const JoinSeaBattleRoomUseCase(this._seaBattleRoomRepository);

  final SeaBattleRoomRepository _seaBattleRoomRepository;

  Future<SeaBattleRoomEntity> call(String code) =>
      _seaBattleRoomRepository.joinRoom(code);
}
