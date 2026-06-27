import 'dart:async';
import 'dart:developer';

import 'package:bardak/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/game_settings/domain/usecases/update_allow_skipping_usecase.dart';
import 'package:bardak/game_settings/domain/usecases/update_points_to_win_usecase.dart';
import 'package:bardak/game_settings/domain/usecases/update_round_duration_usecase.dart';
import 'package:bardak/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/game_settings/presentation/bloc/game_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSettingsBloc extends Bloc<GameSettingsEvent, GameSettingsState> {
  GameSettingsBloc({
    required this.getGameSettingsUseCase,
    required this.updateRoundDurationUseCase,
    required this.updatePointsToWinUseCase,
    required this.updateAllowSkippingUseCase,
  }) : super(GameSettingsState.initial()) {
    on<LoadGameSettings>(_onLoadGameSettings);
    on<ChangeRoundDuration>(_onChangeRoundDuration);
    on<ChangePointsToWin>(_onChangePointsToWin);
    on<ChangeAllowSkipping>(_onChangeAllowSkipping);
  }

  final GetGameSettingsUseCase getGameSettingsUseCase;
  final UpdateRoundDurationUseCase updateRoundDurationUseCase;
  final UpdatePointsToWinUseCase updatePointsToWinUseCase;
  final UpdateAllowSkippingUseCase updateAllowSkippingUseCase;

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

    await updateRoundDurationUseCase(event.roundDuration);
  }

  Future<void> _onChangePointsToWin(
    ChangePointsToWin event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      pointsToWin: event.pointsToWin,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updatePointsToWinUseCase(event.pointsToWin);
  }

  Future<void> _onChangeAllowSkipping(
    ChangeAllowSkipping event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      allowSkipping: event.allowSkipping,
    );
    emit(GameSettingsState(gameSettings: updated));

    await updateAllowSkippingUseCase(allowSkipping: event.allowSkipping);
  }
}
