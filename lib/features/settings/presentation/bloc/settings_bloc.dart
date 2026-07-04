import 'dart:async';
import 'package:bardak/features/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_color_scheme_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_locale_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_sound_enabled_usecase.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required this._getAppSettingsUseCase,
    required this._updateLocaleUseCase,
    required this._updateColorSchemeUseCase,
    required this._updateSoundEnabledUseCase,
    required this._openStoreListingUseCase,
  }) : super(
         SettingsState(appSettings: AppSettingsEntity.defaultSettings()),
       ) {
    on<LoadAppSettings>(_onLoadAppSettings);
    on<ChangeColorScheme>(_onChangeColorScheme);
    on<ChangeLocale>(_onChangeLocale);
    on<ChangeSoundEnabled>(_onChangeSoundEnabled);
    on<OpenStoreListing>(_onOpenStoreListing);
  }

  final GetAppSettingsUseCase _getAppSettingsUseCase;
  final UpdateLocaleUseCase _updateLocaleUseCase;
  final UpdateColorSchemeUseCase _updateColorSchemeUseCase;
  final UpdateSoundEnabledUseCase _updateSoundEnabledUseCase;
  final OpenStoreListingUseCase _openStoreListingUseCase;

  void _onLoadAppSettings(LoadAppSettings event, Emitter<SettingsState> emit) {
    final settings = _getAppSettingsUseCase();
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

    await _updateColorSchemeUseCase(event.colorScheme);

    emit(
      SettingsState(
        appSettings: appSettings.copyWith(colorScheme: event.colorScheme),
      ),
    );
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.appSettings.copyWith(locale: event.locale);
    await _updateLocaleUseCase(event.locale);
    emit(SettingsState(appSettings: newSettings));
  }

  Future<void> _onChangeSoundEnabled(
    ChangeSoundEnabled event,
    Emitter<SettingsState> emit,
  ) async {
    await _updateSoundEnabledUseCase(soundEnabled: event.enabled);
    emit(
      SettingsState(
        appSettings: state.appSettings.copyWith(
          soundEnabled: event.enabled,
        ),
      ),
    );
  }

  Future<void> _onOpenStoreListing(
    OpenStoreListing event,
    Emitter<SettingsState> emit,
  ) => _openStoreListingUseCase();
}
