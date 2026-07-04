import 'package:equatable/equatable.dart';

sealed class TeamSetupEvent extends Equatable {
  const TeamSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Replaces the team names for the current match.
class SetTeamNames extends TeamSetupEvent {
  const SetTeamNames(this.teamNames);

  final List<String> teamNames;

  @override
  List<Object?> get props => [teamNames];
}
