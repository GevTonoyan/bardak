import 'package:boardify/game_session/domain/entities/round_result.dart';
import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'round_review_event.dart';

part 'round_review_state.dart';

class RoundReviewBloc extends Bloc<RoundReviewEvent, RoundReviewState> {
  RoundReviewBloc({
    required List<ReviewedWord> words,
    required GameMode gameMode,
    required int wordsPerCard,
  }) : super(
         RoundReviewState(
           reviewedWords: List<ReviewedWord>.from(words),
           gameMode: gameMode,
           wordsPerCard: wordsPerCard,
         ),
       ) {
    on<WordToggled>(_onWordToggled);
    on<GuessedWordsUpdated>(_onGuessedWordsUpdated);
  }

  void _onWordToggled(
    WordToggled event,
    Emitter<RoundReviewState> emit,
  ) {
    final index = event.index;
    final words = state.reviewedWords;
    if (index < 0 || index >= words.length) return;

    final updated = List<ReviewedWord>.from(words);
    final item = updated[index];
    updated[index] = (word: item.word, isGuessed: !item.isGuessed);
    emit(state.copyWith(reviewedWords: updated));
  }

  void _onGuessedWordsUpdated(
    GuessedWordsUpdated event,
    Emitter<RoundReviewState> emit,
  ) {
    final guessedSet = event.guessedWords;
    final updated = state.reviewedWords
        .map(
          (e) => (word: e.word, isGuessed: guessedSet.contains(e.word)),
        )
        .toList();
    emit(state.copyWith(reviewedWords: updated));
  }
}
