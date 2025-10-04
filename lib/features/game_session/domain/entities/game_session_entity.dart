import 'package:boardify/features/pre_game/domain/entities/pre_game_entity.dart';

class GameSessionEntity {
  GameSessionEntity({
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
    required this.words,
    this.isGameFinished = false,
    this.winningTeamIndex,
  });

  final GameMode gameMode;

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
  late final int currentRoundIndex;

  /// Game end state
  final bool isGameFinished;
  final int? winningTeamIndex;

  /// List of all words
  final List<String> words;

  GameSessionEntity copyWith({
    List<AliasTeamStateEntity>? teamStates,
    int? currentTeamIndex,
    int? currentRoundIndex,
    List<String>? words,
    bool? isGameFinished,
    int? winningTeamIndex,
  }) {
    return GameSessionEntity(
      gameMode: gameMode,
      teamStates: teamStates ?? this.teamStates,
      roundDuration: roundDuration,
      pointsToWin: pointsToWin,
      soundEnabled: soundEnabled,
      wordsPerCard: wordsPerCard,
      allowSkipping: allowSkipping,
      penaltyForSkipping: penaltyForSkipping,
      currentTeamIndex: currentTeamIndex ?? this.currentTeamIndex,
      currentRoundIndex: currentRoundIndex ?? this.currentRoundIndex,
      words: words ?? this.words,
      isGameFinished: isGameFinished ?? this.isGameFinished,
      winningTeamIndex: winningTeamIndex ?? this.winningTeamIndex,
    );
  }
}

extension GameSessionEntityX on GameSessionEntity {
  /// Returns the index of the winning team, or `null` if the game must continue
  int?   getWinningTeamIndex() {
    // 1️⃣ Teams that reached or exceeded pointsToWin
    final qualifiedTeams =
        teamStates
            .asMap()
            .entries
            .where((e) => e.value.totalScore >= pointsToWin)
            .toList();

    // If no one qualified yet → no winner
    if (qualifiedTeams.isEmpty) return null;

    // 2️⃣ If exactly one team qualified → winner
    if (qualifiedTeams.length == 1) {
      return qualifiedTeams.first.key;
    }

    // 3️⃣ If multiple teams qualified → check if one leads
    final maxScore = qualifiedTeams
        .map((e) => e.value.totalScore)
        .reduce((a, b) => a > b ? a : b);

    final topTeams =
        qualifiedTeams.where((e) => e.value.totalScore == maxScore).toList();

    // If tie at top, continue playing
    if (topTeams.length > 1) return null;

    // Otherwise, single leader among qualified → winner
    return topTeams.first.key;
  }
}

class AliasTeamStateEntity {
  AliasTeamStateEntity({required this.name, required this.roundScores});

  final String name;

  /// Score for each card_round (index matches card_round number)
  final List<int> roundScores;

  AliasTeamStateEntity copyWith({String? name, List<int>? roundScores}) {
    return AliasTeamStateEntity(
      name: name ?? this.name,
      roundScores: roundScores ?? this.roundScores,
    );
  }

  void addRoundScore(int score) {
    roundScores.add(score);
  }

  int get totalScore => roundScores.fold(0, (sum, score) => sum + score);
}
