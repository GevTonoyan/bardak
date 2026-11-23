import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// Tells when the opponent has left the battle or lost the connection for
/// good; never, against the bot.
class WatchOpponentLeftUseCase {
  const WatchOpponentLeftUseCase(this._seaBattleOpponentRepository);

  final SeaBattleOpponentRepository _seaBattleOpponentRepository;

  Stream<void> call() => _seaBattleOpponentRepository.watchOpponentLeft();
}
