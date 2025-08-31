part of 'single_word_round_bloc.dart';

class SingleWordRoundState {
  const SingleWordRoundState({
    required this.words,
    required this.score,
    required this.index,
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
    score: 0,
    index: 0,
    roundDuration: roundDuration,
    completed: false,
    allowSkipping: allowSkipping,
    penaltyForSkipping: penaltyForSkipping,
  );

  SingleWordRoundState copyWith({
    List<String>? words,
    int? score,
    int? index,
    int? roundDuration,
    bool? completed,
    bool? allowSkipping,
    bool? penaltyForSkipping,
  }) {
    return SingleWordRoundState(
      words: words ?? this.words,
      score: score ?? this.score,
      index: index ?? this.index,
      roundDuration: roundDuration ?? this.roundDuration,
      completed: completed ?? this.completed,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
    );
  }

  final List<String> words;
  final int score;
  final int index;
  final int roundDuration;
  final bool completed;
  final bool allowSkipping;
  final bool penaltyForSkipping;
}
