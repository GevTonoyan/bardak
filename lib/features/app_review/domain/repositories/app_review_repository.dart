import 'package:bardak/features/app_review/domain/entities/app_review_metrics_entity.dart';

/// Handles store review actions (listing, in-app prompt).
abstract interface class AppReviewRepository {
  /// Opens the App Store / Play Store listing for this app.
  Future<void> openStoreListing();

  AppReviewMetricsEntity getMetrics();

  Future<void> incrementGamesCompleted();

  Future<void> incrementAppOpenedCount();

  Future<void> setLastReviewPromptAt(DateTime dateTime);

  Future<bool> requestInAppReview();
}
