import 'dart:math';

import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_event.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleWordRoundBloc
    extends Bloc<SingleWordRoundEvent, SingleWordRoundState> {
  SingleWordRoundBloc({
    required List<String> words,
    required int roundDuration,
    required bool allowSkipping,
    required bool soundEnabled,
  }) : super(
         SingleWordRoundState(
           words: words,
           roundDuration: roundDuration,
           allowSkipping: allowSkipping,
           soundEnabled: soundEnabled,
         ),
       ) {
    on<ResolveCurrentWord>(_onResolveCurrentWord);
    on<CompleteRound>(_onCompleteRound);
  }

  void _onResolveCurrentWord(
    ResolveCurrentWord event,
    Emitter<SingleWordRoundState> emit,
  ) {
    // A swipe racing the end of the round must not emit another completed
    // state: the UI dispatches FinishRound per completed emission, and a
    // duplicate would skip the next team.
    if (state.completed) return;

    final newScore = switch (event.resolution) {
      .guessed => state.score + 1,
      .skipped => max(0, state.score - 1),
    };

    final isGuessed = event.resolution == .guessed;

    final completed = state.index >= state.words.length - 1;

    emit(
      state.copyWith(
        guessedIndexes: isGuessed
            ? {...state.guessedIndexes, state.index}
            : state.guessedIndexes,
        skippedIndexes: isGuessed
            ? state.skippedIndexes
            : {...state.skippedIndexes, state.index},
        score: newScore,
        index: completed ? state.index : state.index + 1,
        completed: completed,
      ),
    );
  }

  void _onCompleteRound(
    CompleteRound event,
    Emitter<SingleWordRoundState> emit,
  ) {
    if (state.completed) return;
    emit(state.copyWith(completed: true));
  }
}
