import 'dart:async';

import 'package:boardify/features/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/features/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pre_game_event.dart';

part 'pre_game_state.dart';

// TODO(Gevorg): make alias settings repos and data
//  sources in common feature, also get Alias Settings usecase

class PreGameBloc extends Bloc<PreGameEvent, PreGameState> {
  PreGameBloc({required this.getAliasSettingsUseCase})
    : super(const PreGameInitialState()) {
    on<GetPreGameConfig>(_getAliasPreGameConfig);
    on<ChangeGameModeEvent>(_changeGameMode);
    on<ChangeRoundDurationEvent>(_changeRoundDuration);
    on<ChangePointsToWinEvent>(_changePointsToWin);
    on<ChangeWordsPerCardEvent>(_changeWordsPerCard);
    on<ChangeAllowSkippingEvent>(_changeAllowSkipping);
    on<ChangePenaltyForSkippingEvent>(_changePenaltyForSkipping);
    on<AddTeamEvent>(_addTeam);
    on<RemoveTeamEvent>(_removeTeam);
  }

  final GetGameSettingsUseCase getAliasSettingsUseCase;

  FutureOr<void> _getAliasPreGameConfig(
    GetPreGameConfig event,
    Emitter<PreGameState> emit,
  ) async {
    emit(const PreGameLoadingState());
    final result = getAliasSettingsUseCase();

    final preGameConfig = PreGameEntity(
      gameMode: GameMode.card,
      roundDuration: result.roundDuration,
      pointsToWin: result.pointsToWin,
      soundEnabled: result.soundEnabled,
      wordsPerCard: result.wordsPerCard,
      allowSkipping: result.allowSkipping,
      penaltyForSkipping: result.penaltyForSkipping,
      teamNames: event.teamNames,
    );

    emit(PreGameLoadedState(preGameConfig));
  }

  void _changeGameMode(ChangeGameModeEvent event, Emitter<PreGameState> emit) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        gameMode: event.gameMode,
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _changeRoundDuration(
    ChangeRoundDurationEvent event,
    Emitter<PreGameState> emit,
  ) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        roundDuration: event.roundDuration,
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _changePointsToWin(
    ChangePointsToWinEvent event,
    Emitter<PreGameState> emit,
  ) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        pointsToWin: event.pointsToWin,
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _changeWordsPerCard(
    ChangeWordsPerCardEvent event,
    Emitter<PreGameState> emit,
  ) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        wordsPerCard: event.wordsPerCard,
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _changeAllowSkipping(
    ChangeAllowSkippingEvent event,
    Emitter<PreGameState> emit,
  ) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        allowSkipping: event.allowSkipping,
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _changePenaltyForSkipping(
    ChangePenaltyForSkippingEvent event,
    Emitter<PreGameState> emit,
  ) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        penaltyForSkipping: event.penaltyForSkipping,
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _addTeam(AddTeamEvent event, Emitter<PreGameState> emit) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        teamNames: [...currentState.preGameConfig.teamNames, event.teamName],
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }

  void _removeTeam(RemoveTeamEvent event, Emitter<PreGameState> emit) {
    final currentState = state;
    if (currentState is PreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        teamNames: [
          ...currentState.preGameConfig.teamNames..removeAt(event.index),
        ],
      );
      emit(PreGameLoadedState(updatedConfig));
    }
  }
}
