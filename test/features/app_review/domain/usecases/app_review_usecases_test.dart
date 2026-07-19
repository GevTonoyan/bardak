import 'package:bardak/features/app_review/domain/entities/app_review_metrics_entity.dart';
import 'package:bardak/features/app_review/domain/repositories/app_review_repository.dart';
import 'package:bardak/features/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/features/app_review/domain/usecases/record_app_opened_usecase.dart';
import 'package:bardak/features/app_review/domain/usecases/request_review_if_eligible_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppReviewRepository extends Mock implements AppReviewRepository {}

void main() {
  late _MockAppReviewRepository repository;

  setUpAll(() {
    registerFallbackValue(DateTime(2020));
  });

  setUp(() {
    repository = _MockAppReviewRepository();
    when(() => repository.incrementGamesCompleted()).thenAnswer((_) async {});
    when(
      () => repository.setLastReviewPromptAt(any()),
    ).thenAnswer((_) async {});
  });

  AppReviewMetricsEntity metrics({
    int gamesCompleted = 3,
    int appOpenedCount = 3,
    DateTime? lastReviewPromptAt,
  }) {
    return AppReviewMetricsEntity(
      gamesCompleted: gamesCompleted,
      appOpenedCount: appOpenedCount,
      lastReviewPromptAt: lastReviewPromptAt,
    );
  }

  group('RequestReviewIfEligibleUseCase', () {
    test('always records the completed game first', () async {
      when(
        () => repository.getMetrics(),
      ).thenReturn(metrics(gamesCompleted: 0));

      await RequestReviewIfEligibleUseCase(repository)();

      verify(() => repository.incrementGamesCompleted()).called(1);
      verifyNever(() => repository.requestInAppReview());
    });

    test('does not prompt below the games threshold', () async {
      when(
        () => repository.getMetrics(),
      ).thenReturn(metrics(gamesCompleted: 2));

      await RequestReviewIfEligibleUseCase(repository)();

      verifyNever(() => repository.requestInAppReview());
    });

    test('does not prompt below the app-opens threshold', () async {
      when(
        () => repository.getMetrics(),
      ).thenReturn(metrics(appOpenedCount: 2));

      await RequestReviewIfEligibleUseCase(repository)();

      verifyNever(() => repository.requestInAppReview());
    });

    test('prompts an eligible user who was never prompted', () async {
      when(() => repository.getMetrics()).thenReturn(metrics());
      when(() => repository.requestInAppReview()).thenAnswer((_) async => true);

      await RequestReviewIfEligibleUseCase(repository)();

      verify(() => repository.requestInAppReview()).called(1);
      verify(() => repository.setLastReviewPromptAt(any())).called(1);
    });

    test('does not record a prompt time when the OS refused', () async {
      when(() => repository.getMetrics()).thenReturn(metrics());
      when(
        () => repository.requestInAppReview(),
      ).thenAnswer((_) async => false);

      await RequestReviewIfEligibleUseCase(repository)();

      verifyNever(() => repository.setLastReviewPromptAt(any()));
    });

    test('respects the cooldown after a recent prompt', () async {
      when(() => repository.getMetrics()).thenReturn(
        metrics(
          lastReviewPromptAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      );

      await RequestReviewIfEligibleUseCase(repository)();

      verifyNever(() => repository.requestInAppReview());
    });

    test('prompts again once the cooldown elapsed', () async {
      when(() => repository.getMetrics()).thenReturn(
        metrics(
          lastReviewPromptAt: DateTime.now().subtract(const Duration(days: 61)),
        ),
      );
      when(() => repository.requestInAppReview()).thenAnswer((_) async => true);

      await RequestReviewIfEligibleUseCase(repository)();

      verify(() => repository.requestInAppReview()).called(1);
    });
  });

  group('OpenStoreListingUseCase', () {
    test('opens the store listing', () async {
      when(() => repository.openStoreListing()).thenAnswer((_) async {});

      await OpenStoreListingUseCase(repository)();

      verify(() => repository.openStoreListing()).called(1);
    });
  });

  group('RecordAppOpenedUseCase', () {
    test('increments the app opened count', () async {
      when(() => repository.incrementAppOpenedCount()).thenAnswer((_) async {});

      await RecordAppOpenedUseCase(repository)();

      verify(() => repository.incrementAppOpenedCount()).called(1);
    });
  });
}
