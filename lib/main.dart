import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bardak/core/app_ui/theme/app_theme_builder.dart';
import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:bardak/core/logging/app_bloc_observer.dart';
import 'package:bardak/core/router/app_router.dart';
import 'package:bardak/features/app_review/domain/usecases/record_app_opened_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/bloc/team_setup_bloc.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_bloc.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_bloc.dart';
import 'package:bardak/features/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_state.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_bloc.dart';
import 'package:bardak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // By default it is assets/, but our Assets lib already adds assets/
  AudioCache.instance = AudioCache(prefix: '');
  await SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);
  // TODO(Gevorg): come up with nicer way to handle this
  // (add splash screen while loading dependencies)
  await injectDependencies();
  unawaited(sl<RecordAppOpenedUseCase>()());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  Bloc.observer = const AppBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => WordPacksBloc(
            getWordPacksUseCase: sl(),
            getFallbackWordPacksUseCase: sl(),
            areWordPacksCachedUseCase: sl(),
            downloadWordPacksUseCase: sl(),
          )..add(const SyncWordPacks()),
        ),
        BlocProvider(
          create: (_) => SettingsBloc(
            getAppSettingsUseCase: sl(),
            updateLocaleUseCase: sl(),
            updateColorSchemeUseCase: sl(),
            updateSoundEnabledUseCase: sl(),
            openStoreListingUseCase: sl(),
          )..add(const LoadAppSettings()),
        ),
        BlocProvider(
          create: (_) => RewardsCubit(
            getCoinBalanceUseCase: sl(),
            updateCoinBalanceUseCase: sl(),
            watchCoinBalanceUseCase: sl(),
          ),
        ),
        // TODO(GEVORG): make TeamSetupBloc available only where needed,
        //  not for the whole tree
        BlocProvider(
          create: (_) => TeamSetupBloc(getPredefinedTeamNamesUseCase: sl()),
        ),
        BlocProvider(
          create: (_) => ThemesBloc(
            getPurchasedThemesUseCase: sl(),
            purchaseThemeUseCase: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => GameSettingsBloc(
            getGameSettingsUseCase: sl(),
            updateGameModeUseCase: sl(),
            updateRoundDurationUseCase: sl(),
            updatePointsToWinUseCase: sl(),
            updateAllowSkippingUseCase: sl(),
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => SpyPacksBloc(
            getSpyPacksUseCase: sl(),
            getFallbackSpyPacksUseCase: sl(),
            areSpyPacksCachedUseCase: sl(),
            downloadSpyPacksUseCase: sl(),
            drawSpySecretUseCase: sl(),
            getSpySettingsUseCase: sl(),
          )..add(const SyncSpyPacks()),
        ),
        BlocProvider(
          create: (_) => SpySettingsBloc(
            getSpySettingsUseCase: sl(),
            updatePlayerCountUseCase: sl(),
            updateSpyCountUseCase: sl(),
            updateSpyRoundDurationUseCase: sl(),
          ),
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
        final appColor = state.appSettings.colorScheme.colors;

        final themeData = AppThemeData(
          colors: appColor,
          typography: AppTextStyles(),
          themeData: buildAppTheme(AppTextStyles()),
        );

        return AppThemeProvider(
          data: themeData,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            title: 'Bardak',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            locale: state.appSettings.locale.locale,
            theme: themeData.themeData,
          ),
        );
      },
    );
  }
}
