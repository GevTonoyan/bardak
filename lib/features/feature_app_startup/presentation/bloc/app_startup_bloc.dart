import 'dart:async';

import 'package:boardify/core/localizations/common/supported_locales.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_startup_event.dart';

part 'app_startup_state.dart';

class AppStartupBloc extends Bloc<AppStartupEvent, AppStartupState> {
  AppStartupBloc() : super(const AppStartupInitial()) {
    on<GetAppStartupData>(_onGetAppStartupData);
    on<ChangeAppTheme>(_onChangeAppTheme);
    on<ChangeAppLocale>(_onChangeAppLocale);
  }

  Future<void> _onGetAppStartupData(GetAppStartupData event, Emitter<AppStartupState> emit) async {
    emit(const AppStartupLoading());
    try {
      emit(
        AppStartupLoaded(
          appStartupData: AppStartupData(isDarkMode: false, locale: AppLocales.en),
        ),
      );
    } catch (e) {
      emit(const AppStartupInitial());
    }
  }

  void _onChangeAppTheme(ChangeAppTheme event, Emitter<AppStartupState> emit) {
    if (state is! AppStartupLoaded) {
      return;
    }

    final current = (state as AppStartupLoaded).appStartupData;

    emit(AppStartupLoaded(appStartupData: current.copyWith(isDarkMode: event.isDarkMode)));
  }

  void _onChangeAppLocale(ChangeAppLocale event, Emitter<AppStartupState> emit) {
    if (state is! AppStartupLoaded) {
      return;
    }

    final current = (state as AppStartupLoaded).appStartupData;

    emit(AppStartupLoaded(appStartupData: current.copyWith(locale: event.locale)));
  }
}
