import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';

/// The other side of a battle: the bot, or a remote player online.
///
/// The opponent keeps its fleet to itself: it answers the player's shots
/// and fires back, and shows the fleet only once the battle is over.
abstract interface class SeaBattleOpponentRepository {
  /// What the player's shot at [cell] did on the opponent's board.
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell);

  /// The opponent's next shot at the player, aimed using only what it can
  /// see of [playerBoard].
  Future<BoardCoordinate> getOpponentShot(SeaBattleBoardEntity playerBoard);

  /// Tells the opponent what its [shot] did.
  Future<void> reportOpponentShot(ShotEntity shot);

  /// Where the opponent's ships were, once the battle is over.
  Future<FleetEntity> getOpponentFleet();
}
