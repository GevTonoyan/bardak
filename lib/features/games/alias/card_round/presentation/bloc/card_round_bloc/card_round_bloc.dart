import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_event.dart';
import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardRoundBloc extends Bloc<CardRoundEvent, CardRoundState> {
  CardRoundBloc({
    required List<String> words,
    required int wordsPerCard,
    required bool soundEnabled,
  }) : super(
         CardRoundState(
           words: words,
           wordsPerCard: wordsPerCard,
           soundEnabled: soundEnabled,
         ),
       ) {
    on<ToggleWord>(_onToggleWord);
    on<CompleteRound>(_onCompleteRound);
  }

  void _onToggleWord(ToggleWord event, Emitter<CardRoundState> emit) {
    // A tap racing the end of the round must not emit another completed
    // state: the UI dispatches FinishRound per completed emission, and a
    // duplicate would skip the next team.
    if (state.completed) return;

    final guessed = event.isSelected
        ? {...state.guessed, event.word}
        : state.guessed.difference({event.word});

    final next = state.copyWith(guessed: guessed);

    // Deselecting a word can never complete the visible card.
    if (!event.isSelected || !next.visibleAllGuessed) {
      emit(next);
      return;
    }

    // Visible card fully guessed: show the next card, or finish the round
    // (the UI listener pops with the result).
    emit(
      next.isLastPage
          ? next.copyWith(completed: true)
          : next.copyWith(page: next.page + 1),
    );
  }

  void _onCompleteRound(CompleteRound event, Emitter<CardRoundState> emit) {
    if (state.completed) return;

    emit(state.copyWith(completed: true));
  }
}
