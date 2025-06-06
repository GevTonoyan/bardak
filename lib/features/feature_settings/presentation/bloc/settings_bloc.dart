import 'package:app_core/localizations/common/supported_locales.dart';
import 'package:boardify/core/constants.dart';
import 'package:boardify/features/feature_settings/domain/entities/settings_entity.dart';
import 'package:boardify/features/feature_settings/domain/usecases/get_settings_usecase.dart';
import 'package:boardify/features/feature_settings/domain/usecases/update_setting_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsStateLoaded> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingUseCase updateSettingUseCase;

  SettingsBloc({required this.getSettingsUseCase, required this.updateSettingUseCase})
    : super(SettingsStateLoaded(SettingsEntity.defaultSettings())) {
    on<GetSettings>(_getSettings);
    on<ChangeTheme>(_changeTheme);
    on<ChangeLocale>(_changeLocale);
    add(GetSettings());
  }

  void _getSettings(GetSettings event, Emitter<SettingsStateLoaded> emit) {
    final settings = getSettingsUseCase();
    emit(SettingsStateLoaded(settings));
  }

  void _changeTheme(ChangeTheme event, Emitter<SettingsStateLoaded> emit) {
    final newSettings = state.settings.copyWith(isDarkMode: event.isDarkMode);
    emit(SettingsStateLoaded(newSettings));

    updateSettingUseCase(
      UpdateSettingParams(key: AppConstants.appThemeKey, value: event.isDarkMode),
    );
  }

  void _changeLocale(ChangeLocale event, Emitter<SettingsStateLoaded> emit) {
    final newSettings = state.settings.copyWith(locale: event.locale);
    emit(SettingsStateLoaded(newSettings));

    updateSettingUseCase(
      UpdateSettingParams(key: AppConstants.appLocaleKey, value: event.locale.jsonValue()),
    );
  }
}
