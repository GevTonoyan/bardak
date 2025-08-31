part of 'single_word_round_bloc.dart';

class SingleWordRoundState {
  const SingleWordRoundState({
    required this.words,
    required this.guessed,
    required this.roundDuration,
    required this.completed,
    required this.allowSkipping,
    required this.penaltyForSkipping,
  });

  factory SingleWordRoundState.initial({
    required List<String> words,
    required int roundDuration,
    required bool allowSkipping,
    required bool penaltyForSkipping,
  }) => SingleWordRoundState(
    words: words,
    guessed: <String>{},
    roundDuration: roundDuration,
    completed: false,
    allowSkipping: allowSkipping,
    penaltyForSkipping: penaltyForSkipping,
  );

  final List<String> words;
  final Set<String> guessed;
  final int roundDuration;
  final bool completed;
  final bool allowSkipping;
  final bool penaltyForSkipping;
}
