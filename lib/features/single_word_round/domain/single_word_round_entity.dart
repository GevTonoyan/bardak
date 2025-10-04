import 'package:equatable/equatable.dart';

class SingleWordRoundEntity extends Equatable {
  const SingleWordRoundEntity({
    required this.roundDuration,
    required this.allowSkipping,
    required this.penaltyForSkipping,
    required this.words,
  });

  final int roundDuration;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final List<String> words;

  @override
  List<Object> get props => [
    roundDuration,
    allowSkipping,
    penaltyForSkipping,
    words,
  ];
}
