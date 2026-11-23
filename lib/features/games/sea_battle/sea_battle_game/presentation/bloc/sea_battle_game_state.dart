import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:equatable/equatable.dart';

class SeaBattleGameState extends Equatable {
  const SeaBattleGameState({required this.battle, this.turnSecondsLeft});

  final SeaBattleEntity battle;

  /// Seconds left for the current turn; null when turns are not timed
  /// (against the bot) or the battle is over.
  final int? turnSecondsLeft;

  /// This state with [battle] after a shot, keeping the timer as it is.
  SeaBattleGameState withBattle(SeaBattleEntity battle) =>
      SeaBattleGameState(battle: battle, turnSecondsLeft: turnSecondsLeft);

  @override
  List<Object?> get props => [battle, turnSecondsLeft];
}
