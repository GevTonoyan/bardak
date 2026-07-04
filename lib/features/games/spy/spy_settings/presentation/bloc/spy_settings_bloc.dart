import 'package:bardak/features/games/spy/spy_settings/domain/usecases/get_spy_settings_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_player_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_round_duration_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_event.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpySettingsBloc extends Bloc<SpySettingsEvent, SpySettingsState> {
  SpySettingsBloc({
    required GetSpySettingsUseCase getSpySettingsUseCase,
    required this._updatePlayerCountUseCase,
    required this._updateSpyCountUseCase,
    required this._updateSpyRoundDurationUseCase,
  }) : super(SpySettingsState(spySettings: getSpySettingsUseCase())) {
    on<ChangePlayerCount>(_onChangePlayerCount);
    on<ChangeSpyCount>(_onChangeSpyCount);
    on<ChangeRoundDuration>(_onChangeRoundDuration);
  }

  final UpdatePlayerCountUseCase _updatePlayerCountUseCase;
  final UpdateSpyCountUseCase _updateSpyCountUseCase;
  final UpdateSpyRoundDurationUseCase _updateSpyRoundDurationUseCase;

  Future<void> _onChangePlayerCount(
    ChangePlayerCount event,
    Emitter<SpySettingsState> emit,
  ) async {
    var updated = state.spySettings.copyWith(playerCount: event.playerCount);

    // Fewer players can lower the allowed spy maximum.
    final spyCountClamped = updated.spyCount > updated.maxSpyCount;
    if (spyCountClamped) {
      updated = updated.copyWith(spyCount: updated.maxSpyCount);
    }

    emit(SpySettingsState(spySettings: updated));

    await _updatePlayerCountUseCase(updated.playerCount);
    if (spyCountClamped) {
      await _updateSpyCountUseCase(updated.spyCount);
    }
  }

  Future<void> _onChangeSpyCount(
    ChangeSpyCount event,
    Emitter<SpySettingsState> emit,
  ) async {
    final updated = state.spySettings.copyWith(spyCount: event.spyCount);
    emit(SpySettingsState(spySettings: updated));

    await _updateSpyCountUseCase(event.spyCount);
  }

  Future<void> _onChangeRoundDuration(
    ChangeRoundDuration event,
    Emitter<SpySettingsState> emit,
  ) async {
    final updated = state.spySettings.copyWith(
      roundDuration: event.roundDuration,
    );
    emit(SpySettingsState(spySettings: updated));

    await _updateSpyRoundDurationUseCase(event.roundDuration);
  }
}
