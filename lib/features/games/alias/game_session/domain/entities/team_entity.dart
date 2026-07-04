import 'package:equatable/equatable.dart';

/// A team in an Alias match with its per-round score history.
class TeamEntity extends Equatable {
  const TeamEntity({required this.name, this.roundScores = const []});

  final String name;

  /// Score for each played round (index matches round number).
  final List<int> roundScores;

  int get totalScore => roundScores.fold(0, (sum, score) => sum + score);

  /// Returns a copy with [score] appended to the round history.
  TeamEntity withRoundScore(int score) {
    return TeamEntity(name: name, roundScores: [...roundScores, score]);
  }

  /// Returns a copy with the most recent round score replaced by [score].
  TeamEntity withLastRoundScore(int score) {
    return TeamEntity(
      name: name,
      roundScores: [...roundScores.take(roundScores.length - 1), score],
    );
  }

  @override
  List<Object?> get props => [name, roundScores];
}
