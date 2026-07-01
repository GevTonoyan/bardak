import 'package:bardak/features/app_review/data/data_sources/app_review_local_data_source.dart';
import 'package:bardak/features/app_review/data/data_sources/app_review_platform_data_source.dart';
import 'package:bardak/features/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/features/app_review/domain/repositories/app_review_repository.dart';

class AppReviewRepositoryImpl implements AppReviewRepository {
  const AppReviewRepositoryImpl({
    required this._platformDataSource,
    required this._localDataSource,
  });

  final AppReviewPlatformDataSource _platformDataSource;
  final AppReviewLocalDataSource _localDataSource;

  @override
  Future<void> openStoreListing() => _platformDataSource.openStoreListing();

  @override
  AppReviewMetricsEntity getMetrics() => _localDataSource.getMetrics();

  @override
  Future<void> incrementGamesCompleted() =>
      _localDataSource.incrementGamesCompleted();

  @override
  Future<void> incrementAppOpenedCount() =>
      _localDataSource.incrementAppOpenedCount();

  @override
  Future<void> setLastReviewPromptAt(DateTime dateTime) =>
      _localDataSource.setLastReviewPromptAt(dateTime);

  @override
  Future<bool> requestInAppReview() => _platformDataSource.requestInAppReview();
}
