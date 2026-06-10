import 'package:bardak/app_review/domain/usecases/on_game_completed_usecase.dart';
import 'package:bardak/app_review/presentation/bloc/in_app_review_event.dart';
import 'package:bardak/app_review/presentation/bloc/in_app_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InAppReviewBloc extends Bloc<InAppReviewEvent, InAppReviewState> {
  InAppReviewBloc({
    required this.onGameCompletedUseCase,
  }) : super(const InAppReviewInitial()) {
    on<InAppReviewRequested>(_onInAppReviewRequested);
  }

  final OnGameCompletedUseCase onGameCompletedUseCase;

  Future<void> _onInAppReviewRequested(
    InAppReviewRequested event,
    Emitter<InAppReviewState> emit,
  ) async {
    await onGameCompletedUseCase();
  }
}
