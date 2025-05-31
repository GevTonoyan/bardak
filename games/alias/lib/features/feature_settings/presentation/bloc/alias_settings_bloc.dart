import 'dart:async';
import 'package:alias/core/alias_constants.dart';
import 'package:alias/features/feature_settings/domain/entities/alias_settings_entity.dart';
import 'package:alias/features/feature_settings/domain/usecases/get_alias_settings_usecase.dart';
import 'package:alias/features/feature_settings/domain/usecases/update_alias_setting_usecase.dart';
import 'package:alias/features/feature_settings/presentation/bloc/alias_settings_event.dart';
import 'package:alias/features/feature_settings/presentation/bloc/alias_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
