import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'single_word_round_event.dart';

part 'single_word_round_state.dart';

class SingleWordRoundBloc
    extends Bloc<SingleWordRoundEvent, SingleWordRoundState> {
  SingleWordRoundBloc({
    required List<String> words,
    required int roundDuration,
    required bool penaltyForSkipping,
    required bool allowSkipping,
  }) : super(
         SingleWordRoundState.initial(
           words: words,
           roundDuration: roundDuration,
           allowSkipping: allowSkipping,
           penaltyForSkipping: penaltyForSkipping,
         ),
       ) {
    on<ResolveCurrentWord>(_onResolve);
    on<CompleteRoundRequested>(_onCompleteRequested);
  }

  void _onResolve(ResolveCurrentWord e, Emitter<SingleWordRoundState> emit) {
    final newScore = switch (e.resolution) {
      WordResolution.guessed => state.score + 1,
      WordResolution.skipped =>
        state.penaltyForSkipping ? max(0, state.score - 1) : state.score,
    };

    final completed = state.index >= state.words.length - 1;

    emit(
      state.copyWith(
        score: newScore,
        index: completed ? state.index : state.index + 1,
        completed: completed,
      ),
    );
  }

  void _onCompleteRequested(
    CompleteRoundRequested e,
    Emitter<SingleWordRoundState> emit,
  ) {
    if (state.completed) return;
    emit(state.copyWith(completed: true));
  }
}
