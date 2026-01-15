part of 'single_word_round_bloc.dart';

class SingleWordRoundState {
  const SingleWordRoundState({
    required this.words,
    required this.guessedIndexes,
    required this.score,
    required this.index,
    required this.roundDuration,
    required this.completed,
    required this.allowSkipping,
    required this.penaltyForSkipping,
  });

  factory SingleWordRoundState.initial({
    required List<String> words,
    required int roundDuration,
    required bool allowSkipping,
    required bool penaltyForSkipping,
  }) => SingleWordRoundState(
    words: words,
    guessedIndexes: {},
    score: 0,
    index: 0,
    roundDuration: roundDuration,
    completed: false,
    allowSkipping: allowSkipping,
    penaltyForSkipping: penaltyForSkipping,
  );

  SingleWordRoundState copyWith({
    List<String>? words,
    Set<int>? guessedIndexes,
    int? score,
    int? index,
    int? roundDuration,
    bool? completed,
    bool? allowSkipping,
    bool? penaltyForSkipping,
  }) {
    return SingleWordRoundState(
      words: words ?? this.words,
      guessedIndexes: guessedIndexes ?? this.guessedIndexes,
      score: score ?? this.score,
      index: index ?? this.index,
      roundDuration: roundDuration ?? this.roundDuration,
      completed: completed ?? this.completed,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
    );
  }

  final List<String> words;
  final Set<int> guessedIndexes;
  final int score;
  final int index;
  final int roundDuration;
  final bool completed;
  final bool allowSkipping;
  final bool penaltyForSkipping;
}

extension SingleWordRoundStateX on SingleWordRoundState {
  List<ReviewedWord> wordsToReview() {
    final reviewedWords = <ReviewedWord>[];

    for (var i = 0; i <= index; ++i) {
      final word = words[i];
      final isGuessed = guessedIndexes.contains(i);
      reviewedWords.add((word: word, isGuessed: isGuessed));
    }

    return reviewedWords;
  }
}
