import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// Gets where the opponent's ships were, once the battle is over.
class GetOpponentFleetUseCase {
  const GetOpponentFleetUseCase(this._seaBattleOpponentRepository);

  final SeaBattleOpponentRepository _seaBattleOpponentRepository;

  Future<FleetEntity> call() => _seaBattleOpponentRepository.getOpponentFleet();
}
