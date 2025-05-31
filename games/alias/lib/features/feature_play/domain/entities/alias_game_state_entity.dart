import 'package:alias/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';

class AliasGameStateEntity {
  AliasGameStateEntity({
    required this.gameMode,
    required this.teamStates,
    required this.roundDuration,
    required this.pointsToWin,
    required this.soundEnabled,
    required this.wordsPerCard,
    required this.allowSkipping,
    required this.penaltyForSkipping,
    required this.currentTeamIndex,
    required this.currentRoundIndex,
    this.isGameFinished = false,
    this.winningTeamIndex,
  });

  final AliasGameMode gameMode;

  /// Ordered list of team states including score history
  final List<AliasTeamStateEntity> teamStates;

  /// Round settings
  final int roundDuration;
  final int pointsToWin;
  final int wordsPerCard;

  /// Rules
  final bool allowSkipping;
  final bool penaltyForSkipping;

  final bool soundEnabled;

  /// Runtime flow
  final int currentTeamIndex;
  final int currentRoundIndex;

  /// Game end state
  final bool isGameFinished;
  final int? winningTeamIndex;
}

class AliasTeamStateEntity {
  AliasTeamStateEntity({required this.name, required this.roundScores});

  final String name;

  /// Score for each round (index matches round number)
  final List<int> roundScores;

  int get totalScore => roundScores.fold(0, (sum, score) => sum + score);
}
