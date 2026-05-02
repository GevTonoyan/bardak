import 'package:bardak/localizations/common/supported_locales.dart';
import 'package:bardak/pre_game/domain/entities/pre_game_entity.dart';
import 'package:bardak/pre_game/domain/usecases/get_predefined_team_names_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pre_game_event.dart';

part 'pre_game_state.dart';

class PreGameBloc extends Bloc<PreGameEvent, PreGameState> {
  PreGameBloc({required this.getPredefinedTeamNamesUseCase})
    : super(
        PreGameState.initial(
          predefinedTeamNames: getPredefinedTeamNamesUseCase(),
        ),
      ) {
    on<ChangeGameModeEvent>(_changeGameMode);
    on<AddTeamsEvent>(_addTeams);
  }

  final GetPredefinedTeamNamesUseCase getPredefinedTeamNamesUseCase;

  void _changeGameMode(ChangeGameModeEvent event, Emitter<PreGameState> emit) {
    if (state.gameMode == event.gameMode) return;
    emit(state.copyWith(gameMode: event.gameMode));
  }

  void _addTeams(AddTeamsEvent event, Emitter<PreGameState> emit) =>
      emit(state.copyWith(teamNames: event.teamNames));
}
