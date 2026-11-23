import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/exceptions/sea_battle_opponent_exception.dart';
import 'package:equatable/equatable.dart';

class SeaBattleGameState extends Equatable {
  const SeaBattleGameState({
    required this.battle,
    this.turnSecondsLeft,
    this.interruption,
  });

  final SeaBattleEntity battle;

  /// Seconds left for the current turn; null when turns are not timed
  /// (against the bot), the battle is over or it was interrupted.
  final int? turnSecondsLeft;

  /// Why the battle stopped before either fleet was sunk, if it did.
  final SeaBattleOpponentFailure? interruption;

  /// Whether shots can still be fired: the battle is neither over nor
  /// interrupted.
  bool get isPlaying => !battle.isOver && interruption == null;

  /// This state with [battle] after a shot, keeping the timer as it is.
  SeaBattleGameState withBattle(SeaBattleEntity battle) => SeaBattleGameState(
    battle: battle,
    turnSecondsLeft: turnSecondsLeft,
    interruption: interruption,
  );

  @override
  List<Object?> get props => [battle, turnSecondsLeft, interruption];
}
