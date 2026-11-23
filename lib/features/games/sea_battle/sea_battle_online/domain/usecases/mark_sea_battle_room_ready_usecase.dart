import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Tells the room this player's fleet is placed.
class MarkSeaBattleRoomReadyUseCase {
  const MarkSeaBattleRoomReadyUseCase(this._seaBattleRoomRepository);

  final SeaBattleRoomRepository _seaBattleRoomRepository;

  Future<void> call(String code) => _seaBattleRoomRepository.markReady(code);
}
