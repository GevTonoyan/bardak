import 'package:boardify/utils/constants/constants.dart';

/// AliasPreGameConfig is a data class that holds the configuration
/// settings for the Alias game session.
class PreGameEntity {
  const PreGameEntity({
    required this.gameMode,
    required this.roundDuration,
    required this.pointsToWin,
    required this.soundEnabled,
    required this.wordsPerCard,
    required this.allowSkipping,
    required this.penaltyForSkipping,
    required this.teamNames,
    required this.words,
  });

  factory PreGameEntity.initial() {
    return const PreGameEntity(
      roundDuration: AppConstants.defaultRoundDuration,
      pointsToWin: AppConstants.defaultPointsToWin,
      soundEnabled: true,
      allowSkipping: true,
      penaltyForSkipping: true,
      wordsPerCard: AppConstants.defaultWordsPerCard,
      gameMode: GameMode.card,
      teamNames: ['Team 1', 'Team 2'],
      words: [],
    );
  }

  final GameMode gameMode;
  final int roundDuration;
  final int pointsToWin;
  final bool soundEnabled;
  final int wordsPerCard;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final List<String> teamNames;
  final List<String> words;

  PreGameEntity copyWith({
    GameMode? gameMode,
    int? roundDuration,
    int? pointsToWin,
    bool? soundEnabled,
    int? wordsPerCard,
    bool? allowSkipping,
    bool? penaltyForSkipping,
    List<String>? teamNames,
    List<String>? words,
  }) {
    return PreGameEntity(
      gameMode: gameMode ?? this.gameMode,
      roundDuration: roundDuration ?? this.roundDuration,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
      teamNames: teamNames ?? this.teamNames,
      words: words ?? this.words,
    );
  }

  @override
  String toString() {
    return 'AliasPreGameEntity{gameMode: $gameMode,'
        ' roundDuration: $roundDuration,'
        ' pointsToWin: $pointsToWin,'
        ' soundEnabled: $soundEnabled,'
        ' wordsPerCard: $wordsPerCard,'
        ' allowSkipping: $allowSkipping,'
        ' penaltyForSkipping: $penaltyForSkipping,'
        ' teamNames: $teamNames}'
        ' words: $words';
  }
}

enum GameMode {
  card,
  singleWord;

  @override
  String toString() {
    switch (this) {
      case GameMode.card:
        return 'card';
      case GameMode.singleWord:
        return 'single word';
    }
  }
}
