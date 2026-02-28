import 'package:alias_pro/pre_game/domain/entities/pre_game_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pre_game_event.dart';

part 'pre_game_state.dart';

class PreGameBloc extends Bloc<PreGameEvent, PreGameState> {
  PreGameBloc() : super(PreGameState.initial()) {
    on<ChangeGameModeEvent>(_changeGameMode);
    on<AddTeamsEvent>(_addTeams);
  }

  void _changeGameMode(ChangeGameModeEvent event, Emitter<PreGameState> emit) {
    if (state.gameMode == event.gameMode) return;
    emit(state.copyWith(gameMode: event.gameMode));
  }

  void _addTeams(AddTeamsEvent event, Emitter<PreGameState> emit) =>
      emit(state.copyWith(teamNames: event.teamNames));
}
