import 'package:bardak/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';
import 'package:bardak/utils/constants/constants.dart';

class OnGameCompletedUseCase {
  const OnGameCompletedUseCase(this.repository);

  final AppReviewRepository repository;

  Future<void> call() async {
    await repository.incrementGamesCompleted();

    final metrics = repository.getMetrics();
    if (!_isEligibleForReview(metrics)) {
      return;
    }

    final requested = await repository.requestInAppReview();
    if (requested) {
      await repository.setLastReviewPromptAt(DateTime.now());
    }
  }

  bool _isEligibleForReview(AppReviewMetricsEntity metrics) {
    if (metrics.gamesCompleted < AppConstants.minGamesCompletedForReview) {
      return false;
    }

    if (metrics.appOpenedCount < AppConstants.minAppOpenedCountForReview) {
      return false;
    }

    final lastPrompt = metrics.lastReviewPromptAt;
    if (lastPrompt == null) {
      return true;
    }

    final daysSinceLastPrompt = DateTime.now().difference(lastPrompt).inDays;
    return daysSinceLastPrompt >= AppConstants.reviewPromptCooldownDays;
  }
}
