import 'package:bardak/features/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/features/app_review/domain/entities/review_game.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppReviewLocalDataSource {
  AppReviewMetricsEntity getMetrics();

  Future<void> incrementCompletedGames(ReviewGame game);

  Future<void> incrementAppOpenedCount();

  Future<void> setLastReviewPromptAt(DateTime dateTime);
}

class AppReviewLocalDataSourceImpl implements AppReviewLocalDataSource {
  const AppReviewLocalDataSourceImpl({required this._preferences});

  // Per-game counters live under this prefix + the game name, so each game
  // type is counted independently (e.g. 'games_completed_alias').
  static const _completedGamesKeyPrefix = 'games_completed_';
  static const _appOpenedCountKey = 'app_opened_count';
  static const _lastReviewPromptKey = 'last_review_prompt_ms';

  final SharedPreferences _preferences;

  String _completedGamesKey(ReviewGame game) =>
      '$_completedGamesKeyPrefix${game.name}';

  @override
  AppReviewMetricsEntity getMetrics() {
    final completedGames = <ReviewGame, int>{
      for (final game in ReviewGame.values)
        game: _preferences.getInt(_completedGamesKey(game)) ?? 0,
    };
    final appOpenedCount = _preferences.getInt(_appOpenedCountKey) ?? 0;
    final lastPromptMs = _preferences.getInt(_lastReviewPromptKey);

    return AppReviewMetricsEntity(
      completedGames: completedGames,
      appOpenedCount: appOpenedCount,
      lastReviewPromptAt: lastPromptMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastPromptMs),
    );
  }

  @override
  Future<void> incrementCompletedGames(ReviewGame game) async {
    final key = _completedGamesKey(game);
    final current = _preferences.getInt(key) ?? 0;
    await _preferences.setInt(key, current + 1);
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
