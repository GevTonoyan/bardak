import 'package:bardak/features/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/features/app_review/domain/entities/review_game.dart';
import 'package:bardak/features/app_review/domain/repositories/app_review_repository.dart';

/// Records a completed game and requests the native in-app review prompt
/// when the user is eligible: enough games of that game type finished, enough
/// app opens, and the cooldown since the last prompt has elapsed.
///
/// Completions are counted per game type, so finishing two Alias games, two
/// Spy games, or two Sudoku games each independently makes the user eligible.
class RequestReviewIfEligibleUseCase {
  const RequestReviewIfEligibleUseCase(this._appReviewRepository);

  static const minGamesCompletedForReview = 2;
  static const minAppOpenedCountForReview = 3;
  static const reviewPromptCooldownDays = 60;

  final AppReviewRepository _appReviewRepository;

  Future<void> call(ReviewGame game) async {
    await _appReviewRepository.incrementCompletedGames(game);

    final metrics = _appReviewRepository.getMetrics();
    if (!_isEligibleForReview(metrics, game)) {
      return;
    }

    final requested = await _appReviewRepository.requestInAppReview();
    if (requested) {
      await _appReviewRepository.setLastReviewPromptAt(DateTime.now());
    }
  }

  bool _isEligibleForReview(AppReviewMetricsEntity metrics, ReviewGame game) {
    if (metrics.completedGamesFor(game) < minGamesCompletedForReview) {
      return false;
    }

    if (metrics.appOpenedCount < minAppOpenedCountForReview) {
      return false;
    }

    final lastPrompt = metrics.lastReviewPromptAt;
    if (lastPrompt == null) {
      return true;
    }

    final daysSinceLastPrompt = DateTime.now().difference(lastPrompt).inDays;
    return daysSinceLastPrompt >= reviewPromptCooldownDays;
  }
}
