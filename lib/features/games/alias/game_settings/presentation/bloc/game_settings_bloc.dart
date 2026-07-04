import 'package:bardak/features/games/alias/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_allow_skipping_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_game_mode_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_points_to_win_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_round_duration_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSettingsBloc extends Bloc<GameSettingsEvent, GameSettingsState> {
  GameSettingsBloc({
    required GetGameSettingsUseCase getGameSettingsUseCase,
    required this._updateGameModeUseCase,
    required this._updateRoundDurationUseCase,
    required this._updatePointsToWinUseCase,
    required this._updateAllowSkippingUseCase,
  }) : super(GameSettingsState(gameSettings: getGameSettingsUseCase())) {
    on<ChangeGameMode>(_onChangeGameMode);
    on<ChangeRoundDuration>(_onChangeRoundDuration);
    on<ChangePointsToWin>(_onChangePointsToWin);
    on<ChangeAllowSkipping>(_onChangeAllowSkipping);
  }

  final UpdateGameModeUseCase _updateGameModeUseCase;
  final UpdateRoundDurationUseCase _updateRoundDurationUseCase;
  final UpdatePointsToWinUseCase _updatePointsToWinUseCase;
  final UpdateAllowSkippingUseCase _updateAllowSkippingUseCase;

  Future<void> _onChangeGameMode(
    ChangeGameMode event,
    Emitter<GameSettingsState> emit,
  ) async {
    if (state.gameSettings.gameMode == event.gameMode) return;

    final updated = state.gameSettings.copyWith(gameMode: event.gameMode);
    emit(GameSettingsState(gameSettings: updated));

    await _updateGameModeUseCase(event.gameMode);
  }

  Future<void> _onChangeRoundDuration(
    ChangeRoundDuration event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      roundDuration: event.roundDuration,
    );
    emit(GameSettingsState(gameSettings: updated));

    await _updateRoundDurationUseCase(event.roundDuration);
  }

  Future<void> _onChangePointsToWin(
    ChangePointsToWin event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      pointsToWin: event.pointsToWin,
    );
    emit(GameSettingsState(gameSettings: updated));

    await _updatePointsToWinUseCase(event.pointsToWin);
  }

  Future<void> _onChangeAllowSkipping(
    ChangeAllowSkipping event,
    Emitter<GameSettingsState> emit,
  ) async {
    final updated = state.gameSettings.copyWith(
      allowSkipping: event.allowSkipping,
    );
    emit(GameSettingsState(gameSettings: updated));

    await _updateAllowSkippingUseCase(allowSkipping: event.allowSkipping);
  }
}
