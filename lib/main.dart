import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bardak/app_review/domain/usecases/record_app_opened_usecase.dart';
import 'package:bardak/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/app_ui/theme/app_theme/app_theme_data_builder.dart';
import 'package:bardak/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/app_ui/theme/colors/app_black_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_blue_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_brown_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_green_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_grey_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_main_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_mint_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_navy_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_orange_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_pink_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_plum_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_purple_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_red_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_turquoise_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_yellow_colors.dart';
import 'package:bardak/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/firebase_options.dart';
import 'package:bardak/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/localizations/common/supported_locales.dart';
import 'package:bardak/localizations/l10n/app_localizations.dart';
import 'package:bardak/logging/app_bloc_observer.dart';
import 'package:bardak/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:bardak/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:bardak/router/app_router.dart';
import 'package:bardak/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/settings/presentation/bloc/settings_state.dart';
import 'package:bardak/themes/presentation/bloc/themes_bloc.dart';
import 'package:bardak/utils/dependency_injection/di.dart';
import 'package:bardak/word_pack/presentation/bloc/word_packs_bloc.dart';
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
            getWordPacks: sl(),
            areWordPacksCached: sl(),
            fetchAndCacheWordPacks: sl(),
          )..add(const CacheWordPacksIfNeeded()),
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
            getCoinsStateUseCase: sl(),
            updateCoinsUseCase: sl(),
          )..getCoinsState(),
        ),
        // TODO(GEVORG): make PreGameBloc available only where needed,
        //  not for the whole tree
        BlocProvider(
          create: (_) => PreGameBloc(
            getPredefinedTeamNamesUseCase: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => ThemesBloc(
            getPurchasedThemesUseCase: sl(),
            updatePurchasedThemesUseCase: sl(),
          ),
        ),
        BlocProvider(
          create: (_) => GameSettingsBloc(
            getGameSettingsUseCase: sl(),
            updateRoundDurationUseCase: sl(),
            updatePointsToWinUseCase: sl(),
            updateAllowSkippingUseCase: sl(),
          )..add(const LoadGameSettings()),
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
        final appColor = getColors(state.appSettings.colorScheme);

        final themeData = AppThemeData(
          colors: appColor,
          typography: AppTextStyles(),
          themeData: AppThemeDataBuilder(
            colors: appColor,
            textStyles: AppTextStyles(),
          ).build(),
        );

        return AppThemeProvider(
          data: themeData,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            title: 'Bardak',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocales.supportedLocales,
            locale: state.appSettings.locale.locale,
            theme: themeData.themeData,
          ),
        );
      },
    );
  }

  AppColors getColors(AppColorScheme scheme) {
    return switch (scheme) {
      .main => AppMainColors(),
      .purple => AppPurpleColors(),
      .yellow => AppYellowColors(),
      .blue => AppBlueColors(),
      .green => AppGreenColors(),
      .pink => AppPinkColors(),
      .red => AppRedColors(),
      .dark => AppBlackColors(),
      .turquoise => AppTurquoiseColors(),
      .orange => AppOrangeColors(),
      .brown => AppBrownColors(),
      .navy => AppNavyColors(),
      .mint => AppMintColors(),
      .plum => AppPlumColors(),
      .grey => AppGreyColors(),
    };
  }
}
