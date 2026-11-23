import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// Leaves the battle, whether it is over or not, so the opponent is not
/// left waiting.
class LeaveSeaBattleUseCase {
  const LeaveSeaBattleUseCase(this._seaBattleOpponentRepository);

  final SeaBattleOpponentRepository _seaBattleOpponentRepository;

  Future<void> call() => _seaBattleOpponentRepository.leaveBattle();
}
