import 'dart:async';
import 'package:bardak/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:bardak/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/settings/presentation/bloc/settings_state.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required this.getGameSettingsUseCase,
    required this.updateAliasSettingUseCase,
    required this.getAppSettingsUseCase,
    required this.updateAppSettingsUseCase,
    required this.openStoreListingUseCase,
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
    on<ChangeColorScheme>(_changeColorScheme);
    on<ChangeLocale>(_changeLocale);
    on<OpenStoreListingRequested>(_onOpenStoreListingRequested);
  }

  final GetGameSettingsUseCase getGameSettingsUseCase;
  final UpdateGameSettingSUseCase updateAliasSettingUseCase;
  final GetAppSettingsUseCase getAppSettingsUseCase;
  final UpdateAppSettingsUseCase updateAppSettingsUseCase;
  final OpenStoreListingUseCase openStoreListingUseCase;

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

  FutureOr<void> _changeColorScheme(
    ChangeColorScheme event,
    Emitter<SettingsState> emit,
  ) async {
    final appSettings = state.appSettings;
    if (appSettings.colorScheme == event.colorScheme) {
      return;
    }

    final newSettings = appSettings.copyWith(
      colorScheme: event.colorScheme,
    );

    await updateAppSettingsUseCase(
      UpdateAppSettingsParams(
        key: AppConstants.appColorSchemeKey,
        value: event.colorScheme.name,
      ),
    );

    emit(state.copyWith(appSettings: newSettings));
  }

  void _changeLocale(ChangeLocale event, Emitter<SettingsState> emit) {
    final newSettings = state.appSettings.copyWith(locale: event.locale);
    emit(state.copyWith(appSettings: newSettings));

    unawaited(
      updateAppSettingsUseCase(
        UpdateAppSettingsParams(
          key: AppConstants.appLocaleKey,
          value: event.locale.jsonValue(),
        ),
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
    } on Exception catch (_) {
      // TODO(Gevorg): create error handler and logger
    }
  }

  Future<void> _onChangeGameDuration(
    ChangeGameDuration event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.gameSettings.copyWith(
      roundDuration: event.gameDuration,
    );
    emit(state.copyWith(gameSettings: updatedSettings));

    if (event.persist) {
      await updateAliasSettingUseCase(
        UpdateGameSettingsParams(
          key: AppConstants.roundDurationKey,
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
        UpdateGameSettingsParams(
          key: AppConstants.pointsToWinKey,
          value: event.pointsToWin,
        ),
      );
    }
  }

  Future<void> _changeSoundEffects(
    ChangeSoundEffects event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.appSettings.copyWith(
      soundEnabled: event.soundEffects,
    );

    await updateAppSettingsUseCase(
      UpdateAppSettingsParams(
        key: AppConstants.soundEnabledKey,
        value: event.soundEffects,
      ),
    );

    emit(state.copyWith(appSettings: updatedSettings));
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
      UpdateGameSettingsParams(
        key: AppConstants.allowSkippingKey,
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
      UpdateGameSettingsParams(
        key: AppConstants.penaltyForSkippingKey,
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
        UpdateGameSettingsParams(
          key: AppConstants.wordsPerCardKey,
          value: event.wordsPerCard,
        ),
      );
    }
  }

  Future<void> _onOpenStoreListingRequested(
    OpenStoreListingRequested event,
    Emitter<SettingsState> emit,
  ) => openStoreListingUseCase();
}
