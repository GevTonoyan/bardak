import 'dart:async';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/constants.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/get_agame_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_event.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_state.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AliasSettingsBloc extends Bloc<AliasSettingsEvent, SettingsState> {
  final GetGameSettingsUseCase getGameSettingsUseCase;
  final UpdateGameSettingSUseCase updateAliasSettingUseCase;
  final GetAppSettingsUseCase getAppSettingsUseCase;
  final UpdateAppSettingsUseCase updateAppSettingsUseCase;

  AliasSettingsBloc({
    required this.getGameSettingsUseCase,
    required this.updateAliasSettingUseCase,
    required this.getAppSettingsUseCase,
    required this.updateAppSettingsUseCase,
  }) : super(
         SettingsState(
           gameSettings: GameSettingsEntity.initial(),
           appSettings: AppSettingsEntity.defaultSettings(),
         ),
       ) {
    on<GetSettings>(_onGetSettings);
    on<GetAliasSettings>(_onGetAliasSettings);
    on<ChangeGameDuration>(_onChangeGameDuration);
    on<ChangePointsToWin>(_onChangePointsToWin);
    on<ChangeSoundEffects>(_changeSoundEffects);
    on<ChangeAllowSkipping>(_changeAllowSkipping);
    on<ChangePenaltyForSkipping>(_changePenaltyForSkipping);
    on<ChangeWordsPerCard>(_changeWordsPerCard);
    on<GetAppSettings>(_getAppSettings);
    on<ChangeTheme>(_changeTheme);
    on<ChangeLocale>(_changeLocale);
  }

  FutureOr<void> _onGetSettings(
    GetSettings event,
    Emitter<SettingsState> emit,
  ) {
    final appSettings = getAppSettingsUseCase();
    final gameSettings = getGameSettingsUseCase();

    emit(SettingsState(appSettings: appSettings, gameSettings: gameSettings));
  }

  void _getAppSettings(GetAppSettings event, Emitter<SettingsState> emit) {
    final settings = getAppSettingsUseCase();
    emit(state.copyWith(appSettings: settings));
  }

  void _changeTheme(ChangeTheme event, Emitter<SettingsState> emit) {
    final newSettings = state.appSettings.copyWith(
      isDarkMode: event.isDarkMode,
    );
    emit(state.copyWith(appSettings: newSettings));

    updateAppSettingsUseCase(
      UpdateAppSettingsParams(
        key: AppConstants.appThemeKey,
        value: event.isDarkMode,
      ),
    );
  }

  void _changeLocale(ChangeLocale event, Emitter<SettingsState> emit) {
    final newSettings = state.appSettings.copyWith(locale: event.locale);
    emit(state.copyWith(appSettings: newSettings));

    updateAppSettingsUseCase(
      UpdateAppSettingsParams(
        key: AppConstants.appLocaleKey,
        value: event.locale.jsonValue(),
      ),
    );
  }

  FutureOr<void> _onGetAliasSettings(
    GetAliasSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final settings = getGameSettingsUseCase();
      emit(state.copyWith(gameSettings: settings));
    } on Exception catch (e) {
      //TODO create error handler and logger
      print('Error fetching settings: $e');
    }
  }

  void _onChangeGameDuration(
    ChangeGameDuration event,
    Emitter<SettingsState> emit,
  ) {
    final updatedSettings = state.gameSettings.copyWith(
      roundDuration: event.gameDuration,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    if (event.persist) {
      updateAliasSettingUseCase(
        UpdateAliasSettingParams(
          key: AliasConstants.roundDurationKey,
          value: event.gameDuration,
        ),
      );
    }
  }

  void _onChangePointsToWin(
    ChangePointsToWin event,
    Emitter<SettingsState> emit,
  ) {
    final updatedSettings = state.gameSettings.copyWith(
      pointsToWin: event.pointsToWin,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    if (event.persist) {
      updateAliasSettingUseCase(
        UpdateAliasSettingParams(
          key: AliasConstants.pointsToWinKey,
          value: event.pointsToWin,
        ),
      );
    }
  }

  void _changeSoundEffects(
    ChangeSoundEffects event,
    Emitter<SettingsState> emit,
  ) {
    final updatedSettings = state.gameSettings.copyWith(
      soundEnabled: event.soundEffects,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    updateAliasSettingUseCase(
      UpdateAliasSettingParams(
        key: AliasConstants.soundEnabledKey,
        value: event.soundEffects,
      ),
    );
  }

  void _changeAllowSkipping(
    ChangeAllowSkipping event,
    Emitter<SettingsState> emit,
  ) {
    final updatedSettings = state.gameSettings.copyWith(
      allowSkipping: event.allowSkipping,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    updateAliasSettingUseCase(
      UpdateAliasSettingParams(
        key: AliasConstants.allowSkippingKey,
        value: event.allowSkipping,
      ),
    );
  }

  void _changePenaltyForSkipping(
    ChangePenaltyForSkipping event,
    Emitter<SettingsState> emit,
  ) {
    final updatedSettings = state.gameSettings.copyWith(
      penaltyForSkipping: event.penaltyForSkipping,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    updateAliasSettingUseCase(
      UpdateAliasSettingParams(
        key: AliasConstants.penaltyForSkippingKey,
        value: event.penaltyForSkipping,
      ),
    );
  }

  void _changeWordsPerCard(
    ChangeWordsPerCard event,
    Emitter<SettingsState> emit,
  ) {
    final updatedSettings = state.gameSettings.copyWith(
      wordsPerCard: event.wordsPerCard,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    if (event.persist) {
      updateAliasSettingUseCase(
        UpdateAliasSettingParams(
          key: AliasConstants.wordsPerCardKey,
          value: event.wordsPerCard,
        ),
      );
    }
  }
}
