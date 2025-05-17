import 'package:alias/core/alias_constants.dart';

/// AliasPreGameConfig is a data class that holds the configuration settings for the Alias game.
class AliasPreGameConfig {
  final AliasGameMode gameMode;
  final int roundDuration;
  final int pointsToWin;
  final bool soundEnabled;
  final int wordsPerCard;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final List<String> teamNames;

  const AliasPreGameConfig({
    required this.gameMode,
    required this.roundDuration,
    required this.pointsToWin,
    required this.soundEnabled,
    required this.wordsPerCard,
    required this.allowSkipping,
    required this.penaltyForSkipping,
    required this.teamNames,
  });

  factory AliasPreGameConfig.initial() {
    return AliasPreGameConfig(
      roundDuration: AliasConstants.defaultRoundDuration,
      pointsToWin: AliasConstants.defaultPointsToWin,
      soundEnabled: true,
      allowSkipping: true,
      penaltyForSkipping: true,
      wordsPerCard: AliasConstants.defaultWordsPerCard,
      gameMode: AliasGameMode.card,
      teamNames: ['Team 1', 'Team 2'],
    );
  }

  AliasPreGameConfig copyWith({
    AliasGameMode? gameMode,
    int? roundDuration,
    int? pointsToWin,
    bool? soundEnabled,
    int? wordsPerCard,
    bool? allowSkipping,
    bool? penaltyForSkipping,
    List<String>? teamNames,
  }) {
    return AliasPreGameConfig(
      gameMode: gameMode ?? this.gameMode,
      roundDuration: roundDuration ?? this.roundDuration,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
      teamNames: teamNames ?? this.teamNames,
    );
  }

  @override
  String toString() {
    return 'AliasPreGameConfig(gameMode: $gameMode, roundDuration: $roundDuration, pointsToWin: $pointsToWin, soundEnabled: $soundEnabled, wordsPerCard: $wordsPerCard, allowSkipping: $allowSkipping, penaltyForSkipping: $penaltyForSkipping, teamNames: $teamNames)';
  }
}

enum AliasGameMode { card, singleWord }
