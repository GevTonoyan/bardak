import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Starts the battle in a room once both players are ready: picks who
/// fires first. Only the host calls it.
class StartSeaBattleRoomBattleUseCase {
  const StartSeaBattleRoomBattleUseCase(this._seaBattleRoomRepository);

  final SeaBattleRoomRepository _seaBattleRoomRepository;

  Future<void> call(String code) => _seaBattleRoomRepository.startBattle(code);
}
