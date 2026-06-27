/// AliasPreGameConfig is a data class that holds the configuration
/// settings for the Alias game session.
class PreGameEntity {
  const PreGameEntity({
    required this.gameMode,
    required this.teamNames,
    required this.words,
  });

  factory PreGameEntity.initial() {
    return const PreGameEntity(
      gameMode: GameMode.card,
      teamNames: [],
      words: [],
    );
  }

  final GameMode gameMode;
  final List<String> teamNames;
  final List<String> words;

  PreGameEntity copyWith({
    GameMode? gameMode,
    int? roundDuration,
    int? pointsToWin,
    int? wordsPerCard,
    bool? allowSkipping,
    List<String>? teamNames,
    List<String>? words,
  }) {
    return PreGameEntity(
      gameMode: gameMode ?? this.gameMode,
      teamNames: teamNames ?? this.teamNames,
      words: words ?? this.words,
    );
  }

  @override
  String toString() {
    return 'AliasPreGameEntity{gameMode: $gameMode,'
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
