import 'package:bardak/features/app_review/data/data_sources/app_review_local_data_source.dart';
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

    expect(metrics.gamesCompleted, 0);
    expect(metrics.appOpenedCount, 0);
    expect(metrics.lastReviewPromptAt, isNull);
  });

  test('counters increment independently', () async {
    await dataSource.incrementGamesCompleted();
    await dataSource.incrementGamesCompleted();
    await dataSource.incrementAppOpenedCount();

    final metrics = dataSource.getMetrics();
    expect(metrics.gamesCompleted, 2);
    expect(metrics.appOpenedCount, 1);
  });

  test('the last prompt time round-trips', () async {
    final promptedAt = DateTime(2026, 7, 15, 12, 30);

    await dataSource.setLastReviewPromptAt(promptedAt);

    expect(dataSource.getMetrics().lastReviewPromptAt, promptedAt);
  });
}
