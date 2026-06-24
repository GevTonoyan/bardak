import 'dart:async';
import 'package:bardak/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/settings/presentation/bloc/settings_state.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required this.getAppSettingsUseCase,
    required this.updateAppSettingsUseCase,
    required this.openStoreListingUseCase,
  }) : super(
         SettingsState(appSettings: AppSettingsEntity.defaultSettings()),
       ) {
    on<LoadAppSettings>(_onLoadAppSettings);
    on<ChangeColorScheme>(_onChangeColorScheme);
    on<ChangeLocale>(_onChangeLocale);
    on<ChangeSoundEffects>(_onChangeSoundEffects);
    on<OpenStoreListing>(_onOpenStoreListing);
  }

  final GetAppSettingsUseCase getAppSettingsUseCase;
  final UpdateAppSettingsUseCase updateAppSettingsUseCase;
  final OpenStoreListingUseCase openStoreListingUseCase;

  void _onLoadAppSettings(LoadAppSettings event, Emitter<SettingsState> emit) {
    final settings = getAppSettingsUseCase();
    emit(SettingsState(appSettings: settings));
  }

  Future<void> _onChangeColorScheme(
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

    emit(SettingsState(appSettings: newSettings));
  }

  void _onChangeLocale(ChangeLocale event, Emitter<SettingsState> emit) {
    final newSettings = state.appSettings.copyWith(locale: event.locale);
    emit(SettingsState(appSettings: newSettings));

    unawaited(
      updateAppSettingsUseCase(
        UpdateAppSettingsParams(
          key: AppConstants.appLocaleKey,
          value: event.locale.jsonValue(),
        ),
      ),
    );
  }

  Future<void> _onChangeSoundEffects(
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

    emit(SettingsState(appSettings: updatedSettings));
  }

  Future<void> _onOpenStoreListing(
    OpenStoreListing event,
    Emitter<SettingsState> emit,
  ) => openStoreListingUseCase();
}
