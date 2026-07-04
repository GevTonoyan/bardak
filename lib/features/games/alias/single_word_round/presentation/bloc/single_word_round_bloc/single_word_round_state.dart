import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:equatable/equatable.dart';

class SingleWordRoundState extends Equatable {
  const SingleWordRoundState({
    required this.words,
    required this.roundDuration,
    required this.allowSkipping,
    required this.soundEnabled,
    this.guessedIndexes = const <int>{},
    this.skippedIndexes = const <int>{},
    this.score = 0,
    this.index = 0,
    this.completed = false,
  });

  final List<String> words;
  final Set<int> guessedIndexes;
  final Set<int> skippedIndexes;
  final int score;
  final int index;
  final int roundDuration;
  final bool completed;
  final bool allowSkipping;
  final bool soundEnabled;

  List<ReviewedWord> wordsToReview() {
    final reviewedWords = <ReviewedWord>[];

    for (var i = 0; i <= index; ++i) {
      final word = words[i];
      final status = guessedIndexes.contains(i)
          ? WordReviewStatus.guessed
          : skippedIndexes.contains(i)
          ? WordReviewStatus.skipped
          : WordReviewStatus.notGuessed;
      reviewedWords.add((word: word, status: status));
    }

    return reviewedWords;
  }

  SingleWordRoundState copyWith({
    Set<int>? guessedIndexes,
    Set<int>? skippedIndexes,
    int? score,
    int? index,
    bool? completed,
  }) {
    return SingleWordRoundState(
      words: words,
      guessedIndexes: guessedIndexes ?? this.guessedIndexes,
      skippedIndexes: skippedIndexes ?? this.skippedIndexes,
      score: score ?? this.score,
      index: index ?? this.index,
      roundDuration: roundDuration,
      completed: completed ?? this.completed,
      allowSkipping: allowSkipping,
      soundEnabled: soundEnabled,
    );
  }

  @override
  List<Object?> get props => [
    words,
    guessedIndexes,
    skippedIndexes,
    score,
    index,
    roundDuration,
    completed,
    allowSkipping,
    soundEnabled,
  ];
}
