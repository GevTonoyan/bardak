import 'package:equatable/equatable.dart';

typedef ReviewedWord = ({String word, bool isGuessed});

class RoundResult extends Equatable {
  const RoundResult({
    required this.guessedCount,
    required this.seenWordsCount,
    required this.reviewedWords,
  });

  final int guessedCount;
  final int seenWordsCount;
  final List<ReviewedWord> reviewedWords;

  @override
  String toString() {
    return 'Round result{guessedCount: $guessedCount, '
        'seenWordsCount: $seenWordsCount, '
        'reviewedWords: $reviewedWords}';
  }

  @override
  List<Object> get props => [guessedCount, seenWordsCount, reviewedWords];
}
