import 'package:app_core/localizations/common/supported_locales.dart';
import 'package:app_core/localizations/l10n/app_localizations.dart';
import 'package:app_core/ui_kit/theme/app_theme/app_theme_data_builder.dart';
import 'package:app_core/ui_kit/theme/app_theme_provider.dart';
import 'package:app_core/ui_kit/theme/colors/app_dark_colors.dart';
import 'package:app_core/ui_kit/theme/colors/app_light_colors.dart';
import 'package:app_core/ui_kit/theme/text_styles/app_text_styles.dart';
import 'package:boardify/core/dependency_injection/di.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/feature_app_startup/presentation/bloc/app_startup_bloc.dart';
import 'package:boardify/features/feature_settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO come up with nicer way to handle this (add splash screen while loading dependencies)
  await injectDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppStartupBloc()..add(const GetAppStartupData())),
        BlocProvider(
          create:
              (_) =>
                  SettingsBloc(getSettingsUseCase: sl(), updateSettingUseCase: sl())
                    ..add(const GetSettings()),
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
    return BlocBuilder<SettingsBloc, SettingsStateLoaded>(
      builder: (context, state) {
        final appColor = state.settings.isDarkMode ? AppDarkColors() : AppLightColors();

        final themeData = AppThemeData(
          colors: appColor,
          typography: AppTextStyles(),
          themeData: AppThemeDataBuilder(colors: appColor, textStyles: AppTextStyles()).build(),
        );

        return AppThemeProvider(
          data: themeData,
          child: MaterialApp.router(
            routerConfig: appRouter,
            title: 'Boardify',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocales.supportedLocales,
            locale: state.settings.locale.locale,
            theme: themeData.themeData,
          ),
        );
      },
    );
  }
}
