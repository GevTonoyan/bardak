import 'package:bardak/app_review/domain/usecases/request_review_if_eligible_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Thin entry point that triggers the in-app review flow after a game
/// finishes. Holds no state — it just delegates to
/// [RequestReviewIfEligibleUseCase].
class InAppReviewCubit extends Cubit<void> {
  InAppReviewCubit({required this.requestReviewIfEligibleUseCase})
    : super(null);

  final RequestReviewIfEligibleUseCase requestReviewIfEligibleUseCase;

  Future<void> requestReviewAfterGame() => requestReviewIfEligibleUseCase();
}
