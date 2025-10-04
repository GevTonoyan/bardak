import 'package:equatable/equatable.dart';

class CardRoundResult extends Equatable {
  const CardRoundResult({
    required this.guessedCount,
    required this.seenWordsCount,
  });

  final int guessedCount;
  final int seenWordsCount;

  @override
  String toString() {
    return 'CardRoundResult{guessedCount: $guessedCount, '
        'seenWordsCount: $seenWordsCount}';
  }

  @override
  List<Object> get props => [guessedCount, seenWordsCount];
}
