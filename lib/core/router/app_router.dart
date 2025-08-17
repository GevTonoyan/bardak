import 'package:boardify/core/dependency_injection/di.dart';
import 'package:boardify/features/gameplay/presentation/ui/gameplay_screen.dart';
import 'package:boardify/features/gameplay/presentation/ui/round_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/gameplay/presentation/bloc/blocs/gameplay_bloc/gameplay_bloc.dart';
import 'package:boardify/features/gameplay/presentation/ui/countdown_screen.dart';
import 'package:boardify/features/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/features/home/presentation/ui/home_screen.dart';
import 'package:boardify/features/pre_game/domain/entities/alias_pre_game_config.dart';
import 'package:boardify/features/pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: RouteNames.mainMenu,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteNames.mainMenu,
      name: RouteNames.mainMenu,
      builder:
          (context, state) => BlocProvider(
            create:
                (_) => HomeBloc(
                  fetchAndCacheWordPacks: sl(),
                  areWordPacksCached: sl(),
                  getSelectedWordPackName: sl(),
                ),
            child: HomeScreen(), //const AliasMainScreen(),
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
                  (_) => GameplayBloc(
                    teamNames: preGameConfig.teamNames,
                    roundDuration: preGameConfig.roundDuration,
                    pointsToWin: preGameConfig.pointsToWin,
                    wordsPerCard: preGameConfig.wordsPerCard,
                    penaltyForSkipping: preGameConfig.penaltyForSkipping,
                    allowSkipping: preGameConfig.allowSkipping,
                    gameMode: preGameConfig.gameMode,
                    soundEnabled: preGameConfig.soundEnabled,
                  ),
              child: const RoundOverviewScreen(),
            );
          },
          routes: [
            GoRoute(
              path: RouteNames.gameplay,
              name: RouteNames.gameplay,
              builder: (context, state) {
                return const GameplayScreen();
              },
            ),
            GoRoute(
              path: RouteNames.countdown,
              name: RouteNames.countdown,
              builder: (context, state) {
                return const CountdownScreen();
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
