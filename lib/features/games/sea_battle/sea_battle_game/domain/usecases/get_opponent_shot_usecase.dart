import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';

/// Gets the opponent's next shot at the player's board.
///
/// The opponent only gets the board without the player's fleet, so it
/// can never aim at ships it has not found.
class GetOpponentShotUseCase {
  const GetOpponentShotUseCase(this._seaBattleOpponentRepository);

  final SeaBattleOpponentRepository _seaBattleOpponentRepository;

  Future<BoardCoordinate> call(SeaBattleBoardEntity playerBoard) =>
      _seaBattleOpponentRepository.getOpponentShot(playerBoard.withoutFleet);
}
