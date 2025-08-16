part of 'app_config_bloc.dart';

sealed class AppConfigState {
  const AppConfigState();
}

final class AppConfigInitial extends AppConfigState {
  const AppConfigInitial();
}

final class AppConfigLoaded extends AppConfigState {
  const AppConfigLoaded({required bool isDarkMode});
}
