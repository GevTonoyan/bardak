import 'package:bardak/core/localizations/app_locale.dart';
import 'package:equatable/equatable.dart';

class TeamSetupState extends Equatable {
  const TeamSetupState({
    required this.teamNames,
    required this.predefinedTeamNames,
  });

  final List<String> teamNames;
  final Map<AppLocale, Set<String>> predefinedTeamNames;

  TeamSetupState copyWith({
    List<String>? teamNames,
    Map<AppLocale, Set<String>>? predefinedTeamNames,
  }) {
    return TeamSetupState(
      teamNames: teamNames ?? this.teamNames,
      predefinedTeamNames: predefinedTeamNames ?? this.predefinedTeamNames,
    );
  }

  @override
  List<Object?> get props => [teamNames, predefinedTeamNames];
}
