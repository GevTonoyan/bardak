import 'package:boardify/core/dependency_injection/di.dart';
import 'package:boardify/core/localizations/common/supported_locales.dart';
import 'package:boardify/core/localizations/l10n/app_localizations.dart';
import 'package:boardify/core/logging/app_bloc_observer.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/core/ui_kit/theme/app_theme/app_theme_data_builder.dart';
import 'package:boardify/core/ui_kit/theme/app_theme_provider.dart';
import 'package:boardify/core/ui_kit/theme/colors/app_dark_colors.dart';
import 'package:boardify/core/ui_kit/theme/colors/app_light_colors.dart';
import 'package:boardify/core/ui_kit/theme/text_styles/app_text_styles.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:boardify/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(Gevorg): come up with nicer way to handle this
  // (add splash screen while loading dependencies)
  await injectDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO(Gevorg): check path_provider, if not used - remove
  await Hive.initFlutter();

  Bloc.observer = const AppBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => SettingsBloc(
                getGameSettingsUseCase: sl(),
                updateAliasSettingUseCase: sl(),
                getAppSettingsUseCase: sl(),
                updateAppSettingsUseCase: sl(),
              )..add(const GetAppSettings()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final appColor =
            state.appSettings.isDarkMode ? AppDarkColors() : AppLightColors();

        final themeData = AppThemeData(
          colors: appColor,
          typography: AppTextStyles(),
          themeData:
              AppThemeDataBuilder(
                colors: appColor,
                textStyles: AppTextStyles(),
              ).build(),
        );

        return AppThemeProvider(
          data: themeData,
          child: MaterialApp.router(
            routerConfig: appRouter,
            title: 'Boardify',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocales.supportedLocales,
            locale: state.appSettings.locale.locale,
            theme: themeData.themeData,
          ),
        );
      },
    );
  }
}
