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
