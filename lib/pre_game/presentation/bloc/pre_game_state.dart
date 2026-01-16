part of 'pre_game_bloc.dart';

class PreGameState extends Equatable {
  const PreGameState({
    required this.gameMode,
    required this.teamNames,
    required this.words,
  });

  factory PreGameState.initial() {
    return const PreGameState(
      gameMode: GameMode.card,
      teamNames: <String>[],
      words: <String>[],
    );
  }

  final GameMode gameMode;
  final List<String> teamNames;
  final List<String> words;

  PreGameState copyWith({
    GameMode? gameMode,
    List<String>? teamNames,
    List<String>? words,
  }) {
    return PreGameState(
      gameMode: gameMode ?? this.gameMode,
      teamNames: teamNames ?? this.teamNames,
      words: words ?? this.words,
    );
  }

  @override
  List<Object?> get props => [gameMode, teamNames, words];
}
