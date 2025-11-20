import 'package:equatable/equatable.dart';

class CardRoundEntity extends Equatable {
  const CardRoundEntity({
    required this.roundDuration,
    required this.wordsPerCard,
    required this.words,
  });

  final int roundDuration;
  final int wordsPerCard;
  final List<String> words;

  @override
  List<Object> get props => [roundDuration, wordsPerCard, words];
}
