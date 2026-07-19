import 'package:bardak/features/app_review/domain/usecases/request_review_if_eligible_usecase.dart';
import 'package:bardak/features/app_review/presentation/cubit/in_app_review_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestReviewIfEligible extends Mock
    implements RequestReviewIfEligibleUseCase {}

void main() {
  test('requestReviewAfterGame delegates to the use case', () async {
    final requestReview = _MockRequestReviewIfEligible();
    when(requestReview.call).thenAnswer((_) async {});

    final cubit = InAppReviewCubit(
      requestReviewIfEligibleUseCase: requestReview,
    );
    addTearDown(cubit.close);

    await cubit.requestReviewAfterGame();

    verify(requestReview.call).called(1);
  });
}
