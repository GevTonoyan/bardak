import 'package:bardak/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppReviewLocalDataSource {
  AppReviewMetricsEntity getMetrics();

  Future<void> incrementGamesCompleted();

  Future<void> incrementAppOpenedCount();

  Future<void> setLastReviewPromptAt(DateTime dateTime);
}

class AppReviewLocalDataSourceImpl implements AppReviewLocalDataSource {
  const AppReviewLocalDataSourceImpl({required this.preferences});

  static const _gamesCompletedKey = 'games_completed';
  static const _appOpenedCountKey = 'app_opened_count';
  static const _lastReviewPromptKey = 'last_review_prompt_ms';

  final SharedPreferences preferences;

  @override
  AppReviewMetricsEntity getMetrics() {
    final gamesCompleted = preferences.getInt(_gamesCompletedKey) ?? 0;
    final appOpenedCount = preferences.getInt(_appOpenedCountKey) ?? 0;
    final lastPromptMs = preferences.getInt(_lastReviewPromptKey);

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
    final current = preferences.getInt(_gamesCompletedKey) ?? 0;
    await preferences.setInt(_gamesCompletedKey, current + 1);
  }

  @override
  Future<void> incrementAppOpenedCount() async {
    final current = preferences.getInt(_appOpenedCountKey) ?? 0;
    await preferences.setInt(_appOpenedCountKey, current + 1);
  }

  @override
  Future<void> setLastReviewPromptAt(DateTime dateTime) async {
    await preferences.setInt(
      _lastReviewPromptKey,
      dateTime.millisecondsSinceEpoch,
    );
  }
}
