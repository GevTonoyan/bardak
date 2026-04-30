part of 'card_round_bloc.dart';

class CardRoundState extends Equatable {
  const CardRoundState({
    required this.words,
    required this.wordsPerCard,
    required this.page,
    required this.guessed,
    required this.completed,
    required this.soundsEnabled,
  });

  factory CardRoundState.initial({
    required List<String> words,
    required int wordsPerCard,
    required bool soundsEnabled,
  }) => CardRoundState(
    words: words,
    wordsPerCard: wordsPerCard,
    page: 0,
    guessed: const <String>{},
    completed: false,
    soundsEnabled: soundsEnabled,
  );

  final List<String> words;
  final int wordsPerCard;
  final int page;
  final bool soundsEnabled;

  // TODO(Gevorg): words can be repeated, so we need another way to store them
  final Set<String> guessed;
  final bool completed;

  CardRoundState copyWith({int? page, Set<String>? guessed, bool? completed}) {
    return CardRoundState(
      words: words,
      wordsPerCard: wordsPerCard,
      page: page ?? this.page,
      guessed: guessed ?? this.guessed,
      completed: completed ?? this.completed,
      soundsEnabled: soundsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    words,
    wordsPerCard,
    page,
    guessed,
    completed,
    soundsEnabled,
  ];
}

extension CardRoundStateX on CardRoundState {
  List<String> get visible {
    final start = page * wordsPerCard;
    if (start >= totalWords) return const [];
    final end = (start + wordsPerCard).clamp(0, totalWords);
    return words.sublist(start, end);
  }

  bool get visibleAllGuessed =>
      visible.isNotEmpty && visible.every(guessed.contains);

  /// Number of words that have been shown so far
  int get seenWordsCount {
    final end = (page * wordsPerCard) + visible.length;
    return end.clamp(0, totalWords);
  }

  bool get allGuessed => guessed.length == words.length;

  int get totalWords => words.length;

  int get maxPage => (totalWords / wordsPerCard).ceil() - 1;

  List<ReviewedWord> wordsToReview() {
    final reviewedWords = <ReviewedWord>[];

    for (var i = 0; i < seenWordsCount; ++i) {
      final word = words[i];
      final status = guessed.contains(word)
          ? WordReviewStatus.guessed
          : WordReviewStatus.notGuessed;
      reviewedWords.add((word: word, status: status));
    }

    return reviewedWords;
  }
}
