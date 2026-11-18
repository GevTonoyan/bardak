import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/get_sea_battle_settings_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_bot_difficulty_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_mode_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeaBattleSettingsBloc
    extends Bloc<SeaBattleSettingsEvent, SeaBattleSettingsState> {
  SeaBattleSettingsBloc({
    required GetSeaBattleSettingsUseCase getSeaBattleSettingsUseCase,
    required this._updateSeaBattleModeUseCase,
    required this._updateSeaBattleBotDifficultyUseCase,
  }) : super(
         SeaBattleSettingsState(
           seaBattleSettings: getSeaBattleSettingsUseCase(),
         ),
       ) {
    on<ChangeSeaBattleMode>(_onChangeMode, transformer: sequential());
    on<ChangeBotDifficulty>(_onChangeBotDifficulty, transformer: sequential());
  }

  final UpdateSeaBattleModeUseCase _updateSeaBattleModeUseCase;
  final UpdateSeaBattleBotDifficultyUseCase
  _updateSeaBattleBotDifficultyUseCase;

  Future<void> _onChangeMode(
    ChangeSeaBattleMode event,
    Emitter<SeaBattleSettingsState> emit,
  ) async {
    if (state.seaBattleSettings.mode == event.mode) return;

    emit(
      SeaBattleSettingsState(
        seaBattleSettings: state.seaBattleSettings.copyWith(mode: event.mode),
      ),
    );

    await _updateSeaBattleModeUseCase(event.mode);
  }

  Future<void> _onChangeBotDifficulty(
    ChangeBotDifficulty event,
    Emitter<SeaBattleSettingsState> emit,
  ) async {
    if (state.seaBattleSettings.botDifficulty == event.botDifficulty) return;

    emit(
      SeaBattleSettingsState(
        seaBattleSettings: state.seaBattleSettings.copyWith(
          botDifficulty: event.botDifficulty,
        ),
      ),
    );

    await _updateSeaBattleBotDifficultyUseCase(event.botDifficulty);
  }
}
