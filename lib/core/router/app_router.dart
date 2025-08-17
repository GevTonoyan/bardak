import 'package:boardify/features/feature_app_startup/presentation/ui/app_startup_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:boardify/features/feature_main/presentation/ui/alias_main_screen.dart';
import 'package:boardify/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:boardify/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/feature_word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/feature_word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/feature_pre_game/alias_pre_game_scope.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: RouteNames.appStartup,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteNames.appStartup,
      name: RouteNames.appStartup,
      redirect: (context, state) => RouteNames.appStartup,
      builder: (context, state) {
        return const AppStartupScreen();
      },
    ),
    GoRoute(
      path: RouteNames.mainMenu,
      name: RouteNames.mainMenu,
      builder:
          (context, state) => BlocProvider(
            create:
                (_) => AliasMainBloc(
                  fetchAndCacheWordPacks: sl(),
                  areWordPacksCached: sl(),
                  getSelectedWordPackName: sl(),
                ),
            child: AliasMainScreen(), //const AliasMainScreen(),
          ),
      routes: [
        GoRoute(
          path: RouteNames.aliasSettings,
          name: RouteNames.aliasSettings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: RouteNames.info,
          name: RouteNames.info,
          builder: (context, state) => const AliasRulesScreen(),
        ),
        GoRoute(
          path: RouteNames.wordPacks,
          name: RouteNames.wordPacks,
          builder:
              (context, state) => BlocProvider(
                create:
                    (_) => AliasWordPacksBloc(
                      getWordPacks: sl(),
                      setSelectedWordPack: sl(),
                    ),
                child: const AliasWordPackScreen(),
              ),
        ),
        GoRoute(
          path: RouteNames.preGame,
          name: RouteNames.preGame,
          builder:
              (context, state) => BlocProvider(
                create: (_) => AliasPreGameBloc(getAliasSettingsUseCase: sl()),
                child: const AliasPreGameScreen(),
              ),
        ),

        GoRoute(
          path: RouteNames.roundOverview,
          name: RouteNames.roundOverview,
          builder: (context, state) {
            final preGameConfigString =
                state.uri.queryParameters[AliasConstants.preGameConfigKey]
                    as String;
            final preGameConfig = AliasPreGameConfig.fromJson(
              preGameConfigString,
            );

            return BlocProvider(
              create:
                  (_) => AliasGameplayBloc(
                    teamNames: preGameConfig.teamNames,
                    roundDuration: preGameConfig.roundDuration,
                    pointsToWin: preGameConfig.pointsToWin,
                    wordsPerCard: preGameConfig.wordsPerCard,
                    penaltyForSkipping: preGameConfig.penaltyForSkipping,
                    allowSkipping: preGameConfig.allowSkipping,
                    gameMode: preGameConfig.gameMode,
                    soundEnabled: preGameConfig.soundEnabled,
                  ),
              child: const AliasRoundOverviewScreen(),
            );
          },
          routes: [
            GoRoute(
              path: RouteNames.gameplay,
              name: RouteNames.gameplay,
              builder: (context, state) {
                return const AliasGameplayScreen();
              },
            ),
            GoRoute(
              path: RouteNames.countdown,
              name: RouteNames.countdown,
              builder: (context, state) {
                return const AliasCountdownScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class RouteNames {
  static const initial = '/';
  static const appStartup = '/app_startup';
  static const mainMenu = '/alias_main';
  static const aliasSettings = 'settings';
  static const info = 'info';
  static const wordPacks = 'word_packs';
  static const preGame = 'pre_game';

  static const playSession = 'alias_play_session';
  static const roundOverview = 'alias_round_overview';
  static const countdown = 'alias_countdown';
  static const gameplay = 'alias_gameplay';
  static const gameSummary = 'alias_game_summary';
}
