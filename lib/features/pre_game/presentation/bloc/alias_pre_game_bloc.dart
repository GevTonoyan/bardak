import 'dart:async';

import 'package:boardify/features/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:boardify/features/pre_game/domain/entities/alias_pre_game_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


 part 'alias_pre_game_event.dart';

part 'alias_pre_game_state.dart';

// TODO make aliassettings repos and data sources in common feature, also get Alias Settings usecase

class AliasPreGameBloc extends Bloc<AliasPreGameEvent, AliasPreGameState> {
  final GetGameSettingsUseCase getAliasSettingsUseCase;

  AliasPreGameBloc({required this.getAliasSettingsUseCase})
    : super(const AliasPreGameInitialState()) {
    on<GetAliasPreGameConfig>(_getAliasPreGameConfig);
    on<ChangeGameModeEvent>(_changeGameMode);
    on<ChangeRoundDurationEvent>(_changeRoundDuration);
    on<ChangePointsToWinEvent>(_changePointsToWin);
    on<ChangeWordsPerCardEvent>(_changeWordsPerCard);
    on<ChangeAllowSkippingEvent>(_changeAllowSkipping);
    on<ChangePenaltyForSkippingEvent>(_changePenaltyForSkipping);
    on<AddTeamEvent>(_addTeam);
    on<RemoveTeamEvent>(_removeTeam);
  }

  FutureOr<void> _getAliasPreGameConfig(
    GetAliasPreGameConfig event,
    Emitter<AliasPreGameState> emit,
  ) async {
    emit(const AliasPreGameLoadingState());
    final result = getAliasSettingsUseCase();

    final preGameConfig = AliasPreGameConfig(
      gameMode: AliasGameMode.card,
      roundDuration: result.roundDuration,
      pointsToWin: result.pointsToWin,
      soundEnabled: result.soundEnabled,
      wordsPerCard: result.wordsPerCard,
      allowSkipping: result.allowSkipping,
      penaltyForSkipping: result.penaltyForSkipping,
      teamNames: event.teamNames,
    );

    emit(AliasPreGameLoadedState(preGameConfig));
  }

  void _changeGameMode(ChangeGameModeEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(gameMode: event.gameMode);
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _changeRoundDuration(ChangeRoundDurationEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(roundDuration: event.roundDuration);
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _changePointsToWin(ChangePointsToWinEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(pointsToWin: event.pointsToWin);
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _changeWordsPerCard(ChangeWordsPerCardEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(wordsPerCard: event.wordsPerCard);
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _changeAllowSkipping(ChangeAllowSkippingEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(allowSkipping: event.allowSkipping);
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _changePenaltyForSkipping(
    ChangePenaltyForSkippingEvent event,
    Emitter<AliasPreGameState> emit,
  ) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        penaltyForSkipping: event.penaltyForSkipping,
      );
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _addTeam(AddTeamEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        teamNames: [...currentState.preGameConfig.teamNames, event.teamName],
      );
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }

  void _removeTeam(RemoveTeamEvent event, Emitter<AliasPreGameState> emit) {
    final currentState = state;
    if (currentState is AliasPreGameLoadedState) {
      final updatedConfig = currentState.preGameConfig.copyWith(
        teamNames: [...currentState.preGameConfig.teamNames..removeAt(event.index)],
      );
      emit(AliasPreGameLoadedState(updatedConfig));
    }
  }
}
