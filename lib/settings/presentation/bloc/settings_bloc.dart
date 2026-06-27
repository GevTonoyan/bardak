import 'dart:async';
import 'package:bardak/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/settings/domain/usecases/update_color_scheme_usecase.dart';
import 'package:bardak/settings/domain/usecases/update_locale_usecase.dart';
import 'package:bardak/settings/domain/usecases/update_sound_enabled_usecase.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required this.getAppSettingsUseCase,
    required this.updateLocaleUseCase,
    required this.updateColorSchemeUseCase,
    required this.updateSoundEnabledUseCase,
    required this.openStoreListingUseCase,
  }) : super(
         SettingsState(appSettings: AppSettingsEntity.defaultSettings()),
       ) {
    on<LoadAppSettings>(_onLoadAppSettings);
    on<ChangeColorScheme>(_onChangeColorScheme);
    on<ChangeLocale>(_onChangeLocale);
    on<ChangeSoundEnabled>(_onChangeSoundEnabled);
    on<OpenStoreListing>(_onOpenStoreListing);
  }

  final GetAppSettingsUseCase getAppSettingsUseCase;
  final UpdateLocaleUseCase updateLocaleUseCase;
  final UpdateColorSchemeUseCase updateColorSchemeUseCase;
  final UpdateSoundEnabledUseCase updateSoundEnabledUseCase;
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

    await updateColorSchemeUseCase(event.colorScheme);

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
    await updateLocaleUseCase(event.locale);
    emit(SettingsState(appSettings: newSettings));
  }

  Future<void> _onChangeSoundEnabled(
    ChangeSoundEnabled event,
    Emitter<SettingsState> emit,
  ) async {
    await updateSoundEnabledUseCase(soundEnabled: event.enabled);
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
  ) => openStoreListingUseCase();
}
