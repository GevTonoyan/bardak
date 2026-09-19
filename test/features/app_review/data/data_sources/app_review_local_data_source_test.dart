import 'package:bardak/features/app_review/data/data_sources/app_review_local_data_source.dart';
import 'package:bardak/features/app_review/domain/entities/review_game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppReviewLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    dataSource = AppReviewLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  test('metrics start at zero with no prompt recorded', () {
    final metrics = dataSource.getMetrics();

    for (final game in ReviewGame.values) {
      expect(metrics.completedGamesFor(game), 0);
    }
    expect(metrics.appOpenedCount, 0);
    expect(metrics.lastReviewPromptAt, isNull);
  });

  test('each game type is counted independently', () async {
    await dataSource.incrementCompletedGames(ReviewGame.alias);
    await dataSource.incrementCompletedGames(ReviewGame.alias);
    await dataSource.incrementCompletedGames(ReviewGame.spy);
    await dataSource.incrementAppOpenedCount();

    final metrics = dataSource.getMetrics();
    expect(metrics.completedGamesFor(ReviewGame.alias), 2);
    expect(metrics.completedGamesFor(ReviewGame.spy), 1);
    expect(metrics.completedGamesFor(ReviewGame.sudoku), 0);
    expect(metrics.appOpenedCount, 1);
  });

  test('the last prompt time round-trips', () async {
    final promptedAt = DateTime(2026, 7, 15, 12, 30);

    await dataSource.setLastReviewPromptAt(promptedAt);

    expect(dataSource.getMetrics().lastReviewPromptAt, promptedAt);
  });
}
