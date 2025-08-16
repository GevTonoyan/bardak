import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_config_event.dart';

part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  AppConfigBloc() : super(AppConfigInitial()) {
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<AppConfigState> emit) async {
    emit(AppConfigLoaded(isDarkMode: event.isDarkMode));
  }
}
