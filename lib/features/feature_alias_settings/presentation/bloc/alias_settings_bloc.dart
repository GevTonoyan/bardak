import 'dart:async';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/alias_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/get_alias_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_alias_setting_usecase.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_bloc.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_event.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_state.dart';
import 'package:boardify/features/feature_alias_settings/presentation/ui/alias_settings_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
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

class AliasSettingsBloc extends Bloc<AliasSettingsEvent, AliasSettingsLoaded> {
  final GetAliasSettingsUseCase getAliasSettingsUseCase;
  final UpdateAliasSettingUseCase updateAliasSettingUseCase;

  AliasSettingsBloc({
    required this.getAliasSettingsUseCase,
    required this.updateAliasSettingUseCase,
  }) : super(AliasSettingsLoaded(aliasSettings: AliasSettingsEntity.initial())) {
    on<GetAliasSettings>(_onGetAliasSettings);
    on<ChangeGameDuration>(_onChangeGameDuration);
    on<ChangePointsToWin>(_onChangePointsToWin);
    on<ChangeSoundEffects>(_changeSoundEffects);
    on<ChangeAllowSkipping>(_changeAllowSkipping);
    on<ChangePenaltyForSkipping>(_changePenaltyForSkipping);
    on<ChangeWordsPerCard>(_changeWordsPerCard);
  }

  FutureOr<void> _onGetAliasSettings(
    GetAliasSettings event,
    Emitter<AliasSettingsLoaded> emit,
  ) async {
    try {
      final settings = await getAliasSettingsUseCase();
      emit(AliasSettingsLoaded(aliasSettings: settings));
    } on Exception catch (e) {
      //TODO create error handler and logger
      print('Error fetching settings: $e');
    }
  }

  void _onChangeGameDuration(ChangeGameDuration event, Emitter<AliasSettingsLoaded> emit) {
    final updatedSettings = state.aliasSettings.copyWith(roundDuration: event.gameDuration);
    emit(AliasSettingsLoaded(aliasSettings: updatedSettings));

    if (event.persist) {
      updateAliasSettingUseCase(
        UpdateAliasSettingParams(key: AliasConstants.roundDurationKey, value: event.gameDuration),
      );
    }
  }

  void _onChangePointsToWin(ChangePointsToWin event, Emitter<AliasSettingsLoaded> emit) {
    final updatedSettings = state.aliasSettings.copyWith(pointsToWin: event.pointsToWin);
    emit(AliasSettingsLoaded(aliasSettings: updatedSettings));

    if (event.persist) {
      updateAliasSettingUseCase(
        UpdateAliasSettingParams(key: AliasConstants.pointsToWinKey, value: event.pointsToWin),
      );
    }
  }

  void _changeSoundEffects(ChangeSoundEffects event, Emitter<AliasSettingsLoaded> emit) {
    final updatedSettings = state.aliasSettings.copyWith(soundEnabled: event.soundEffects);
    emit(AliasSettingsLoaded(aliasSettings: updatedSettings));

    updateAliasSettingUseCase(
      UpdateAliasSettingParams(key: AliasConstants.soundEnabledKey, value: event.soundEffects),
    );
  }

  void _changeAllowSkipping(ChangeAllowSkipping event, Emitter<AliasSettingsLoaded> emit) {
    final updatedSettings = state.aliasSettings.copyWith(allowSkipping: event.allowSkipping);
    emit(AliasSettingsLoaded(aliasSettings: updatedSettings));

    updateAliasSettingUseCase(
      UpdateAliasSettingParams(key: AliasConstants.allowSkippingKey, value: event.allowSkipping),
    );
  }

  void _changePenaltyForSkipping(
    ChangePenaltyForSkipping event,
    Emitter<AliasSettingsLoaded> emit,
  ) {
    final updatedSettings = state.aliasSettings.copyWith(
      penaltyForSkipping: event.penaltyForSkipping,
    );
    emit(AliasSettingsLoaded(aliasSettings: updatedSettings));

    updateAliasSettingUseCase(
      UpdateAliasSettingParams(
        key: AliasConstants.penaltyForSkippingKey,
        value: event.penaltyForSkipping,
      ),
    );
  }

  void _changeWordsPerCard(ChangeWordsPerCard event, Emitter<AliasSettingsLoaded> emit) {
    final updatedSettings = state.aliasSettings.copyWith(wordsPerCard: event.wordsPerCard);
    emit(AliasSettingsLoaded(aliasSettings: updatedSettings));

    if (event.persist) {
      updateAliasSettingUseCase(
        UpdateAliasSettingParams(key: AliasConstants.wordsPerCardKey, value: event.wordsPerCard),
      );
    }
  }
}
