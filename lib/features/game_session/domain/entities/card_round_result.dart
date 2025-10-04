import 'package:equatable/equatable.dart';

class RoundResult extends Equatable {
  const RoundResult({required this.guessedCount, required this.seenWordsCount});

  final int guessedCount;
  final int seenWordsCount;

  @override
  String toString() {
    return 'Round result{guessedCount: $guessedCount, '
        'seenWordsCount: $seenWordsCount}';
  }

  @override
  List<Object> get props => [guessedCount, seenWordsCount];
}
