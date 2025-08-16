part of 'app_config_bloc.dart';

sealed class AppConfigEvent {
  const AppConfigEvent();
}

final class ChangeTheme extends AppConfigEvent {
  const ChangeTheme({required this.isDarkMode});

  final bool isDarkMode;
}
