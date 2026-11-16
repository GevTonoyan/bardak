import 'package:bardak/features/app_review/domain/entities/review_game.dart';
import 'package:equatable/equatable.dart';

class AppReviewMetricsEntity extends Equatable {
  const AppReviewMetricsEntity({
    required this.completedGames,
    required this.appOpenedCount,
    this.lastReviewPromptAt,
  });

  /// Completed-game counts keyed by game type; a missing key means zero.
  final Map<ReviewGame, int> completedGames;
  final int appOpenedCount;
  final DateTime? lastReviewPromptAt;

  /// How many games of [game] the user has finished.
  int completedGamesFor(ReviewGame game) => completedGames[game] ?? 0;

  @override
  List<Object?> get props => [
    completedGames,
    appOpenedCount,
    lastReviewPromptAt,
  ];
}
