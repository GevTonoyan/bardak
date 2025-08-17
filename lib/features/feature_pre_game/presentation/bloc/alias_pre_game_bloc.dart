import 'dart:async';

import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:boardify/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';
import 'package:boardify/features/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/feature_gameplay/domain/entities/alias_game_state_entity.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_local_data_source.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_remote_data_source.dart';
import 'package:boardify/features/feature_main/data/repositories/alias_main_repository_impl.dart';
import 'package:boardify/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/feature_main/domain/repositories/alias_main_repository.dart';
import 'package:boardify/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:boardify/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:boardify/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:boardify/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/feature_word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/feature_word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/ui_kit/widgets/alias_setting_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final result = await getAliasSettingsUseCase();

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
