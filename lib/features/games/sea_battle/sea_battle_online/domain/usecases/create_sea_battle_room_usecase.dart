import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Creates a room with this player as its host.
class CreateSeaBattleRoomUseCase {
  const CreateSeaBattleRoomUseCase(this._seaBattleRoomRepository);

  final SeaBattleRoomRepository _seaBattleRoomRepository;

  Future<SeaBattleRoomEntity> call() => _seaBattleRoomRepository.createRoom();
}
