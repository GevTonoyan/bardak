import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/team_entity.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:equatable/equatable.dart';

/// Full in-memory state of one Alias match.
class GameSessionEntity extends Equatable {
  const GameSessionEntity({
    required this.gameMode,
    required this.teams,
    required this.roundDuration,
    required this.pointsToWin,
    required this.soundEnabled,
    required this.wordsPerCard,
    required this.allowSkipping,
    required this.remainingWords,
    this.currentTeamIndex = 0,
    this.previousTeamIndex = 0,
    this.currentRoundIndex = 0,
    this.isGameFinished = false,
    this.winningTeamIndex,
    this.pendingReviewWords,
  });

  final GameMode gameMode;

  /// Ordered list of teams including score history.
  final List<TeamEntity> teams;

  /// Round settings
  final int roundDuration;
  final int pointsToWin;
  final int wordsPerCard;

  /// Rules
  final bool allowSkipping;

  final bool soundEnabled;

  /// Runtime flow
  final int currentTeamIndex;
  final int previousTeamIndex;
  final int currentRoundIndex;

  /// Game end state
  final bool isGameFinished;
  final int? winningTeamIndex;

  /// Words not yet played in any round.
  final List<String> remainingWords;

  /// Words from the last finished round, available for review corrections.
  final List<ReviewedWord>? pendingReviewWords;

  GameSessionEntity copyWith({
    List<TeamEntity>? teams,
    int? currentTeamIndex,
    int? previousTeamIndex,
    int? currentRoundIndex,
    List<String>? remainingWords,
    bool? isGameFinished,
    int? winningTeamIndex,
    List<ReviewedWord>? pendingReviewWords,
  }) {
    return GameSessionEntity(
      gameMode: gameMode,
      teams: teams ?? this.teams,
      roundDuration: roundDuration,
      pointsToWin: pointsToWin,
      soundEnabled: soundEnabled,
      wordsPerCard: wordsPerCard,
      allowSkipping: allowSkipping,
      currentTeamIndex: currentTeamIndex ?? this.currentTeamIndex,
      previousTeamIndex: previousTeamIndex ?? this.previousTeamIndex,
      currentRoundIndex: currentRoundIndex ?? this.currentRoundIndex,
      remainingWords: remainingWords ?? this.remainingWords,
      isGameFinished: isGameFinished ?? this.isGameFinished,
      winningTeamIndex: winningTeamIndex ?? this.winningTeamIndex,
      pendingReviewWords: pendingReviewWords ?? this.pendingReviewWords,
    );
  }

  /// Index of the winning team, or `null` while the game must continue.
  int? findWinningTeamIndex() {
    // Teams that reached or exceeded pointsToWin.
    final qualifiedTeams = teams
        .asMap()
        .entries
        .where((e) => e.value.totalScore >= pointsToWin)
        .toList();

    if (qualifiedTeams.isEmpty) return null;

    if (qualifiedTeams.length == 1) {
      return qualifiedTeams.first.key;
    }

    // Multiple teams qualified: only a single leader wins.
    final maxScore = qualifiedTeams
        .map((e) => e.value.totalScore)
        .reduce((a, b) => a > b ? a : b);

    final topTeams = qualifiedTeams
        .where((e) => e.value.totalScore == maxScore)
        .toList();

    // Tie at the top: keep playing.
    if (topTeams.length > 1) return null;

    return topTeams.first.key;
  }

  @override
  List<Object?> get props => [
    gameMode,
    teams,
    roundDuration,
    pointsToWin,
    wordsPerCard,
    allowSkipping,
    soundEnabled,
    currentTeamIndex,
    previousTeamIndex,
    currentRoundIndex,
    isGameFinished,
    winningTeamIndex,
    remainingWords,
    pendingReviewWords,
  ];
}
