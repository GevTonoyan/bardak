import 'package:flutter_bloc/flutter_bloc.dart';

part 'card_round_event.dart';

part 'card_round_state.dart';

class CardRoundBloc extends Bloc<CardRoundEvent, CardRoundState> {
  CardRoundBloc({required List<String> words, required int wordsPerCard})
    : super(CardRoundState.initial(words: words, wordsPerCard: wordsPerCard)) {
    on<ToggleWord>(_onToggleWord);
    on<CompleteRoundRequested>(_onCompleteRoundRequested);
  }

  void _onToggleWord(ToggleWord event, Emitter<CardRoundState> emit) {
    final guessed = {...state.guessed};

    // UNSELECT → we already know the card isn't "all guessed" anymore
    if (!event.isSelected) {
      guessed.remove(event.word);
      emit(state.copyWith(guessed: guessed));
      return;
    }

    guessed.add(event.word);
    final nextState = state.copyWith(guessed: guessed);

    // Is the current visible card fully guessed now?
    final cardComplete = nextState.visibleAllGuessed;

    if (!cardComplete) {
      // Not complete → no page change
      emit(nextState);
      return;
    }

    if (nextState.page < nextState.maxPage) {
      emit(nextState.copyWith(page: state.page + 1));
      return;
    }

    // Last page complete → mark completed; UI listener will pop with result
    emit(nextState.copyWith(completed: true));
  }

  void _onCompleteRoundRequested(
    CompleteRoundRequested e,
    Emitter<CardRoundState> emit,
  ) {
    if (state.completed) return;

    emit(state.copyWith(completed: true));
  }
}
