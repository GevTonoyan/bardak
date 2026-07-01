import 'package:bardak/features/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppReviewLocalDataSource {
  AppReviewMetricsEntity getMetrics();

  Future<void> incrementGamesCompleted();

  Future<void> incrementAppOpenedCount();

  Future<void> setLastReviewPromptAt(DateTime dateTime);
}

class AppReviewLocalDataSourceImpl implements AppReviewLocalDataSource {
  const AppReviewLocalDataSourceImpl({required this._preferences});

  static const _gamesCompletedKey = 'games_completed';
  static const _appOpenedCountKey = 'app_opened_count';
  static const _lastReviewPromptKey = 'last_review_prompt_ms';

  final SharedPreferences _preferences;

  @override
  AppReviewMetricsEntity getMetrics() {
    final gamesCompleted = _preferences.getInt(_gamesCompletedKey) ?? 0;
    final appOpenedCount = _preferences.getInt(_appOpenedCountKey) ?? 0;
    final lastPromptMs = _preferences.getInt(_lastReviewPromptKey);

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
    final current = _preferences.getInt(_gamesCompletedKey) ?? 0;
    await _preferences.setInt(_gamesCompletedKey, current + 1);
  }

  @override
  Future<void> incrementAppOpenedCount() async {
    final current = _preferences.getInt(_appOpenedCountKey) ?? 0;
    await _preferences.setInt(_appOpenedCountKey, current + 1);
  }

  @override
  Future<void> setLastReviewPromptAt(DateTime dateTime) async {
    await _preferences.setInt(
      _lastReviewPromptKey,
      dateTime.millisecondsSinceEpoch,
    );
  }
}
