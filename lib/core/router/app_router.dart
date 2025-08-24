import 'package:boardify/core/dependency_injection/di.dart';
import 'package:boardify/features/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/features/game_session/presentation/ui/game_session_screen.dart';
import 'package:boardify/features/round/presentation/ui/card_round_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/features/home/presentation/ui/home_screen.dart';
import 'package:boardify/features/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:boardify/features/pre_game/presentation/ui/pre_game_screen.dart';
import 'package:boardify/features/rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final gameSessionNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: HomeScreen.routePath,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: HomeScreen.routePath,
      name: HomeScreen.routePath,
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
          path: SettingsScreen.routePath,
          name: SettingsScreen.routePath,
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
          path: PreGameScreen.routePath,
          name: PreGameScreen.routePath,
          builder:
              (context, state) => BlocProvider(
                create: (_) => PreGameBloc(getAliasSettingsUseCase: sl()),
                child: const PreGameScreen(),
              ),
          routes: [
            GoRoute(
              path: GameSessionScreen.routePath,
              name: GameSessionScreen.routePath,
              builder: (context, state) {
                final gameSessionEntity = state.extra as GameSessionEntity?;
                return GameSessionScreen(gameSessionEntity: gameSessionEntity);
              },
              routes: [
                GoRoute(
                  path: RouteNames.cardRound,
                  name: RouteNames.cardRound,
                  builder: (context, state) {
                    return const CardRoundScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class RouteNames {
  static const initial = '/';
  static const info = 'info';
  static const wordPacks = 'word_packs';

  static const countdown = 'countdown';
  static const gameplay = 'gameplay';
  static const gameSummary = 'game_summary';
  static const cardRound = 'card_round';
}
