part of 'round_review_bloc.dart';

class RoundReviewState extends Equatable {
  const RoundReviewState({
    required this.reviewedWords,
    required this.gameMode,
    required this.wordsPerCard,
  });

  final List<ReviewedWord> reviewedWords;
  final GameMode gameMode;
  final int wordsPerCard;

  int get guessedCount => reviewedWords.where((e) => e.status.isGuessed).length;

  Map<int, List<ReviewedWord>> get pagedReviewedWords {
    if (reviewedWords.isEmpty) return const <int, List<ReviewedWord>>{};
    final pages = <int, List<ReviewedWord>>{};
    for (
      var start = 0, page = 0;
      start < reviewedWords.length;
      start += wordsPerCard, page++
    ) {
      final end = (start + wordsPerCard) > reviewedWords.length
          ? reviewedWords.length
          : (start + wordsPerCard);
      pages[page] = reviewedWords.sublist(start, end);
    }
    return pages;
  }

  /// Guessed words per page index, for card review UI.
  Map<int, Set<String>> get guessedByPage {
    final paged = pagedReviewedWords;
    return {
      for (final entry in paged.entries)
        entry.key: entry.value
            .where((e) => e.status.isGuessed)
            .map((e) => e.word)
            .toSet(),
    };
  }

  RoundReviewState copyWith({
    List<ReviewedWord>? reviewedWords,
    GameMode? gameMode,
    int? wordsPerCard,
  }) {
    return RoundReviewState(
      reviewedWords: reviewedWords ?? this.reviewedWords,
      gameMode: gameMode ?? this.gameMode,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
    );
  }

  @override
  List<Object?> get props => [reviewedWords, gameMode, wordsPerCard];
}
