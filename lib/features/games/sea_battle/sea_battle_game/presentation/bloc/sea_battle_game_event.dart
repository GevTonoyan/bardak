import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:equatable/equatable.dart';

sealed class SeaBattleGameEvent extends Equatable {
  const SeaBattleGameEvent();

  @override
  List<Object?> get props => [];
}

/// The player fires at [cell] on the opponent's board.
final class FireShot extends SeaBattleGameEvent {
  const FireShot(this.cell);

  final BoardCoordinate cell;

  @override
  List<Object?> get props => [cell];
}

/// The opponent takes its turn: fires at the player's board and gets the
/// answer.
final class PlayOpponentTurn extends SeaBattleGameEvent {
  const PlayOpponentTurn();
}

/// Follows the opponent, to stop the battle if they leave.
final class WatchOpponent extends SeaBattleGameEvent {
  const WatchOpponent();
}

/// Counts down the time for the current turn from the start. At zero, on
/// the player's own turn, fires a random shot for them; on the
/// opponent's, whose own phone does the same, it waits a little longer
/// before counting them as gone. Sent again after every shot, which
/// restarts it.
final class RunTurnTimer extends SeaBattleGameEvent {
  const RunTurnTimer();
}
