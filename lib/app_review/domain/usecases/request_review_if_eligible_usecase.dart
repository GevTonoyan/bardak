import 'package:bardak/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

/// Records a completed game and requests the native in-app review prompt
/// when the user is eligible (enough games played and app opens, and the
/// cooldown since the last prompt has elapsed).
class RequestReviewIfEligibleUseCase {
  const RequestReviewIfEligibleUseCase(this._appReviewRepository);

  static const minGamesCompletedForReview = 3;
  static const minAppOpenedCountForReview = 3;
  static const reviewPromptCooldownDays = 60;

  final AppReviewRepository _appReviewRepository;

  Future<void> call() async {
    await _appReviewRepository.incrementGamesCompleted();

    final metrics = _appReviewRepository.getMetrics();
    if (!_isEligibleForReview(metrics)) {
      return;
    }

    final requested = await _appReviewRepository.requestInAppReview();
    if (requested) {
      await _appReviewRepository.setLastReviewPromptAt(DateTime.now());
    }
  }

  bool _isEligibleForReview(AppReviewMetricsEntity metrics) {
    if (metrics.gamesCompleted < minGamesCompletedForReview) {
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
