import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Leaves a room, closing it for both players.
class LeaveSeaBattleRoomUseCase {
  const LeaveSeaBattleRoomUseCase(this._seaBattleRoomRepository);

  final SeaBattleRoomRepository _seaBattleRoomRepository;

  Future<void> call(String code) => _seaBattleRoomRepository.leaveRoom(code);
}
