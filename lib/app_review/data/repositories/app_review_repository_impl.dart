import 'package:bardak/app_review/data/data_sources/app_review_local_data_source.dart';
import 'package:bardak/app_review/data/data_sources/app_review_platform_data_source.dart';
import 'package:bardak/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

class AppReviewRepositoryImpl implements AppReviewRepository {
  const AppReviewRepositoryImpl({
    required this.platformDataSource,
    required this.localDataSource,
  });

  final AppReviewPlatformDataSource platformDataSource;
  final AppReviewLocalDataSource localDataSource;

  @override
  Future<void> openStoreListing() => platformDataSource.openStoreListing();

  @override
  AppReviewMetricsEntity getMetrics() => localDataSource.getMetrics();

  @override
  Future<void> incrementGamesCompleted() =>
      localDataSource.incrementGamesCompleted();

  @override
  Future<void> incrementAppOpenedCount() =>
      localDataSource.incrementAppOpenedCount();

  @override
  Future<void> setLastReviewPromptAt(DateTime dateTime) =>
      localDataSource.setLastReviewPromptAt(dateTime);

  @override
  Future<bool> requestInAppReview() => platformDataSource.requestInAppReview();
}
