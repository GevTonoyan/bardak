part of 'pre_game_bloc.dart';

class PreGameState extends Equatable {
  const PreGameState({
    required this.gameMode,
    required this.teamNames,
    required this.words,
    required this.predefinedTeamNames,
  });

  factory PreGameState.initial({
    required Map<AppLocale, Set<String>> predefinedTeamNames,
  }) {
    return PreGameState(
      gameMode: GameMode.card,
      teamNames: const <String>[],
      words: const <String>[],
      predefinedTeamNames: predefinedTeamNames,
    );
  }

  final GameMode gameMode;
  final List<String> teamNames;
  final List<String> words;
  final Map<AppLocale, Set<String>> predefinedTeamNames;

  PreGameState copyWith({
    GameMode? gameMode,
    List<String>? teamNames,
    List<String>? words,
    Map<AppLocale, Set<String>>? predefinedTeamNames,
  }) {
    return PreGameState(
      gameMode: gameMode ?? this.gameMode,
      teamNames: teamNames ?? this.teamNames,
      words: words ?? this.words,
      predefinedTeamNames: predefinedTeamNames ?? this.predefinedTeamNames,
    );
  }

  @override
  List<Object?> get props => [gameMode, teamNames, words, predefinedTeamNames];
}
