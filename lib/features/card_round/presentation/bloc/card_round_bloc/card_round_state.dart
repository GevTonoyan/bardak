part of 'card_round_bloc.dart';

class CardRoundState {
  const CardRoundState({
    required this.words,
    required this.wordsPerCard,
    required this.page,
    required this.guessed,
    required this.completed,
  });

  factory CardRoundState.initial({
    required List<String> words,
    required int wordsPerCard,
  }) => CardRoundState(
    words: words,
    wordsPerCard: wordsPerCard,
    page: 0,
    guessed: <String>{},
    completed: false,
  );

  final List<String> words;
  final int wordsPerCard;
  final int page;
  final Set<String> guessed;
  final bool completed;

  CardRoundState copyWith({int? page, Set<String>? guessed, bool? completed}) {
    return CardRoundState(
      words: words,
      wordsPerCard: wordsPerCard,
      page: page ?? this.page,
      guessed: guessed ?? this.guessed,
      completed: completed ?? this.completed,
    );
  }
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
}
