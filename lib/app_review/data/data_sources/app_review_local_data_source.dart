import 'package:bardak/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppReviewLocalDataSource {
  AppReviewMetricsEntity getMetrics();

  Future<void> incrementGamesCompleted();

  Future<void> incrementAppOpenedCount();

  Future<void> setLastReviewPromptAt(DateTime dateTime);
}

class AppReviewLocalDataSourceImpl implements AppReviewLocalDataSource {
  const AppReviewLocalDataSourceImpl({required this.preferences});

  final SharedPreferences preferences;

  @override
  AppReviewMetricsEntity getMetrics() {
    final gamesCompleted =
        preferences.getInt(AppConstants.gamesCompletedKey) ?? 0;
    final appOpenedCount =
        preferences.getInt(AppConstants.appOpenedCountKey) ?? 0;
    final lastPromptMs = preferences.getInt(AppConstants.lastReviewPromptKey);

    return AppReviewMetricsEntity(
      gamesCompleted: gamesCompleted,
      appOpenedCount: appOpenedCount,
      lastReviewPromptAt: lastPromptMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastPromptMs),
    );
  }

  @override
  Future<void> incrementGamesCompleted() async {
    final current = preferences.getInt(AppConstants.gamesCompletedKey) ?? 0;
    await preferences.setInt(AppConstants.gamesCompletedKey, current + 1);
  }

  @override
  Future<void> incrementAppOpenedCount() async {
    final current = preferences.getInt(AppConstants.appOpenedCountKey) ?? 0;
    await preferences.setInt(AppConstants.appOpenedCountKey, current + 1);
  }

  @override
  Future<void> setLastReviewPromptAt(DateTime dateTime) async {
    await preferences.setInt(
      AppConstants.lastReviewPromptKey,
      dateTime.millisecondsSinceEpoch,
    );
  }
}
