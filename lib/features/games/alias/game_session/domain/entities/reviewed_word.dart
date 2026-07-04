import 'dart:math';

/// Resolution of a word in a round: guessed, skipped, or not guessed.
enum WordReviewStatus {
  guessed,
  skipped,
  notGuessed,
}

extension WordReviewStatusX on WordReviewStatus {
  bool get isGuessed => this == WordReviewStatus.guessed;
}

typedef ReviewedWord = ({String word, WordReviewStatus status});

extension ReviewedWordsX on List<ReviewedWord> {
  /// Round score: +1 per guessed word, -1 per skipped word.
  ///
  /// Clamped at zero after every word (in play order), mirroring the live
  /// in-round score, so the total never goes negative.
  int get totalScore => fold(
    0,
    (score, word) => switch (word.status) {
      .guessed => score + 1,
      .skipped => max(0, score - 1),
      .notGuessed => score,
    },
  );
}
