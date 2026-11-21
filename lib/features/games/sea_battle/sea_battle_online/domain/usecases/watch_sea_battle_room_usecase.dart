import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Follows a room live; emits null once the room is gone.
class WatchSeaBattleRoomUseCase {
  const WatchSeaBattleRoomUseCase(this._seaBattleRoomRepository);

  final SeaBattleRoomRepository _seaBattleRoomRepository;

  Stream<SeaBattleRoomEntity?> call(String code) =>
      _seaBattleRoomRepository.watchRoom(code);
}
