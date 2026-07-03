import 'package:bardak/features/games/alias/team_setup/domain/usecases/get_predefined_team_names_usecase.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/bloc/team_setup_event.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/bloc/team_setup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamSetupBloc extends Bloc<TeamSetupEvent, TeamSetupState> {
  TeamSetupBloc({
    required GetPredefinedTeamNamesUseCase getPredefinedTeamNamesUseCase,
  }) : super(
         TeamSetupState(
           teamNames: const [],
           predefinedTeamNames: getPredefinedTeamNamesUseCase(),
         ),
       ) {
    on<SetTeamNames>(_onSetTeamNames);
  }

  void _onSetTeamNames(SetTeamNames event, Emitter<TeamSetupState> emit) =>
      emit(state.copyWith(teamNames: event.teamNames));
}
