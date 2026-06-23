import 'dart:async';
import 'dart:developer';

import 'package:bardak/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/game_settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:bardak/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/game_settings/presentation/bloc/game_settings_state.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSettingsBloc extends Bloc<GameSettingsEvent, GameSettingsState> {
  GameSettingsBloc({
    required this.getGameSettingsUseCase,
    required this.updateGameSettingsUseCase,
  }) : super(GameSettingsState.initial()) {
    on<LoadGameSettings>(_onLoadGameSettings);
    on<ChangeRoundDuration>(_onChangeRoundDuration);
    on<ChangePointsToWin>(_onChangePointsToWin);
    on<ChangeWordsPerCard>(_onChangeWordsPerCard);
    on<ChangeAllowSkipping>(_onChangeAllowSkipping);
    on<ChangePenaltyForSkipping>(_onChangePenaltyForSkipping);
  }

  final GetGameSettingsUseCase getGameSettingsUseCase;
  final UpdateGameSettingsUseCase updateGameSettingsUseCase;

  void _onLoadGameSettings(
    LoadGameSettings event,
    Emitter<GameSettingsState> emit,
  ) {
    try {
      final settings = getGameSettingsUseCase();
      emit(GameSettingsState(gameSettings: settings));
    } on Exception catch (error, stackTrace) {
      log('Failed to load game settings', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _onChangeRoundDuration(
    ChangeRoundDuration event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      roundDuration: event.roundDuration,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updateGameSettingsUseCase(
      UpdateGameSettingsParams(
        key: AppConstants.roundDurationKey,
        value: event.roundDuration,
      ),
    );
  }

  Future<void> _onChangePointsToWin(
    ChangePointsToWin event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      pointsToWin: event.pointsToWin,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updateGameSettingsUseCase(
      UpdateGameSettingsParams(
        key: AppConstants.pointsToWinKey,
        value: event.pointsToWin,
      ),
    );
  }

  Future<void> _onChangeWordsPerCard(
    ChangeWordsPerCard event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      wordsPerCard: event.wordsPerCard,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updateGameSettingsUseCase(
      UpdateGameSettingsParams(
        key: AppConstants.wordsPerCardKey,
        value: event.wordsPerCard,
      ),
    );
  }

  Future<void> _onChangeAllowSkipping(
    ChangeAllowSkipping event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      allowSkipping: event.allowSkipping,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updateGameSettingsUseCase(
      UpdateGameSettingsParams(
        key: AppConstants.allowSkippingKey,
        value: event.allowSkipping,
      ),
    );
  }

  Future<void> _onChangePenaltyForSkipping(
    ChangePenaltyForSkipping event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      penaltyForSkipping: event.penaltyForSkipping,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updateGameSettingsUseCase(
      UpdateGameSettingsParams(
        key: AppConstants.penaltyForSkippingKey,
        value: event.penaltyForSkipping,
      ),
    );
  }
}
