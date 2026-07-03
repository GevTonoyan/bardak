import 'package:bardak/features/games/alias/game_session/domain/entities/round_result.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
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
    updated[index] = (
      word: item.word,
      status: _toggleStatus(current: item.status, index: index),
    );
    emit(state.copyWith(reviewedWords: updated));
  }

  WordReviewStatus _toggleStatus({
    required WordReviewStatus current,
    required int index,
  }) {
    final isLastWord = index == state.reviewedWords.length - 1;

    return switch (current) {
      WordReviewStatus.guessed =>
        (state.gameMode == GameMode.singleWord && !isLastWord)
            ? WordReviewStatus.skipped
            : WordReviewStatus.notGuessed,

      _ => WordReviewStatus.guessed,
    };
  }

  void _onGuessedWordsUpdated(
    GuessedWordsUpdated event,
    Emitter<RoundReviewState> emit,
  ) {
    final guessedSet = event.guessedWords;
    final updated = state.reviewedWords
        .map(
          (e) => (
            word: e.word,
            status: guessedSet.contains(e.word)
                ? WordReviewStatus.guessed
                : WordReviewStatus.notGuessed,
          ),
        )
        .toList();
    emit(state.copyWith(reviewedWords: updated));
  }
}
