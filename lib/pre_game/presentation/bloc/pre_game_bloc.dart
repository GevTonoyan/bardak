import 'dart:async';

import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:boardify/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pre_game_event.dart';

part 'pre_game_state.dart';

// TODO(Gevorg): make alias settings repos and data
//  sources in common feature, also get Alias Settings usecase

class PreGameBloc extends Bloc<PreGameEvent, PreGameState> {
  PreGameBloc({
    required this.getAliasSettingsUseCase,
    required this.getWordsByPack,
  }) : super(const PreGameInitialState()) {
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
  final GetWordsByPackUseCase getWordsByPack;

  FutureOr<void> _getAliasPreGameConfig(
    GetPreGameConfig event,
    Emitter<PreGameState> emit,
  ) async {
    emit(const PreGameLoadingState());
    final settings = getAliasSettingsUseCase();
    final words = await getWordsByPack(
      GetWordsByPackParams(localeCode: event.localeCode),
    );

    final preGameConfig = PreGameEntity(
      gameMode: GameMode.card,
      roundDuration: settings.roundDuration,
      pointsToWin: settings.pointsToWin,
      soundEnabled: settings.soundEnabled,
      wordsPerCard: settings.wordsPerCard,
      allowSkipping: settings.allowSkipping,
      penaltyForSkipping: settings.penaltyForSkipping,
      teamNames: event.teamNames,
      words: words,
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
