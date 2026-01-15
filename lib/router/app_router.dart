import 'package:boardify/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:boardify/card_round/presentation/ui/card_round_screen.dart';
import 'package:boardify/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/game_session/presentation/ui/game_session_screen.dart';
import 'package:boardify/game_session/presentation/ui/game_summary_screen.dart';
import 'package:boardify/game_session/presentation/ui/round_overview_screen.dart';
import 'package:boardify/game_session/presentation/ui/round_review_screen.dart';
import 'package:boardify/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/home/presentation/ui/home_screen.dart';
import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:boardify/pre_game/presentation/ui/pre_game_screen.dart';
import 'package:boardify/pre_game/presentation/ui/pre_game_settings_screen.dart';
import 'package:boardify/pre_game/presentation/ui/setup_team_names_screen.dart';
import 'package:boardify/rewards/presentation/ui/rewards_screen.dart';
import 'package:boardify/rules/presentation/ui/rules_screen.dart';
import 'package:boardify/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/settings/presentation/ui/settings_screen_v2.dart';
import 'package:boardify/shop/presentation/ui/shop_screen.dart';
import 'package:boardify/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:boardify/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:boardify/utils/dependency_injection/di.dart';
import 'package:boardify/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:boardify/word_pack/presentation/ui/word_packs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();
final gameSessionNavigatorKey = GlobalKey<NavigatorState>();

const _gameSessionPath = 'gameSession';

final appRouter = GoRouter(
  initialLocation: HomeScreen.routePath,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: HomeScreen.routePath,
      name: HomeScreen.routePath,
      builder: (context, state) => BlocProvider(
        create: (_) => HomeBloc(
          fetchAndCacheWordPacks: sl(),
          areWordPacksCached: sl(),
          getSelectedWordPackName: sl(),
          getWordsVersion: sl(),
        ),
        child: const HomeScreen(), //const AliasMainScreen(),
      ),
      routes: [
        GoRoute(
          path: SettingsScreen.routePath,
          name: SettingsScreen.routePath,
          pageBuilder: (context, state) {
            return const SettingsScreenV2();
          },
        ),
        GoRoute(
          path: PreGameSettingsScreen.routePath,
          name: PreGameSettingsScreen.routePath,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final params = state.uri.queryParameters;
            final gameModeString = params[PreGameSettingsScreen.gameModeKey]!;
            final gameMode = GameMode.values.firstWhere(
              (mode) => mode.name == gameModeString,
            );
            return PreGameSettingsScreen(selectedMode: gameMode);
          },
          routes: [
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: SetupTeamNamesScreen.routePath,
              name: SetupTeamNamesScreen.routePath,
              pageBuilder: (context, state) {
                return const SetupTeamNamesScreen();
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: rootNavigatorKey,
                  path: WordPackScreen.routePath,
                  name: WordPackScreen.routePath,
                  builder: (context, state) => BlocProvider(
                    create: (_) => WordPacksBloc(
                      getWordPacks: sl(),
                      setSelectedWordPack: sl(),
                    ),
                    child: const WordPackScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RewardsScreen.routePath,
          name: RewardsScreen.routePath,
          builder: (context, state) => const RewardsScreen(),
        ),
        GoRoute(
          path: ShopScreen.routePath,
          name: ShopScreen.routePath,
          builder: (context, state) => const ShopScreen(),
        ),
        GoRoute(
          path: RouteNames.info,
          name: RouteNames.info,
          builder: (context, state) => const RulesScreen(),
        ),
        // GoRoute(
        //   path: RouteNames.wordPacks,
        //   name: RouteNames.wordPacks,
        //   builder: (context, state) => BlocProvider(
        //     create: (_) => WordPacksBloc(
        //       getWordPacks: sl(),
        //       setSelectedWordPack: sl(),
        //     ),
        //     child: const WordPackScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: PreGameScreen.routePath,
        //   name: PreGameScreen.routePath,
        //   builder: (context, state) => BlocProvider(
        //     create: (_) => PreGameBloc(
        //       getAliasSettingsUseCase: sl(),
        //       getWordsByPack: sl(),
        //     ),
        //     child: const PreGameScreen(),
        //   ),
        // ),
        GoRoute(
          path: PreGameScreen.routePath,
          name: PreGameScreen.routePath,
          builder: (context, state) => BlocProvider(
            create: (_) => PreGameBloc(
              getAliasSettingsUseCase: sl(),
              getWordsByPack: sl(),
            ),
            child: const PreGameScreen(),
          ),
        ),

        ShellRoute(
          navigatorKey: gameSessionNavigatorKey,
          builder: (context, state, child) {
            final gameSessionEntity = state.extra as GameSessionEntity?;
            return GameSessionScreen(
              gameSessionEntity: gameSessionEntity,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '$_gameSessionPath/${RoundOverviewScreen.routePath}',
              name: RoundOverviewScreen.routePath,
              builder: (context, state) => const RoundOverviewScreen(),
            ),
            GoRoute(
              path: '$_gameSessionPath/${CardRoundScreen.routePath}',
              name: CardRoundScreen.routePath,
              builder: (context, state) {
                final gameState = context
                    .read<GameSessionBloc>()
                    .state
                    .gameState;

                return BlocProvider(
                  create: (_) => CardRoundBloc(
                    words: gameState.words,
                    wordsPerCard: gameState.wordsPerCard,
                  ),
                  child: CardRoundScreen(
                    initialRoundDuration: gameState.roundDuration,
                  ),
                );
              },
            ),
            GoRoute(
              path: '$_gameSessionPath/${SingleWordRoundScreen.routePath}',
              name: SingleWordRoundScreen.routePath,
              builder: (context, state) {
                final gameState = context
                    .read<GameSessionBloc>()
                    .state
                    .gameState;

                return BlocProvider(
                  create: (_) => SingleWordRoundBloc(
                    words: gameState.words,
                    roundDuration: gameState.roundDuration,
                    allowSkipping: gameState.allowSkipping,
                    penaltyForSkipping: gameState.penaltyForSkipping,
                  ),
                  child: const SingleWordRoundScreen(),
                );
              },
            ),
            GoRoute(
              path: '$_gameSessionPath/${RoundReviewScreen.routePath}',
              name: RoundReviewScreen.routePath,
              builder: (context, state) {
                return const RoundReviewScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: GameSummaryScreen.routePath,
          name: GameSummaryScreen.routePath,
          builder: (context, state) {
            final teamStates = state.extra! as List<AliasTeamStateEntity>;
            final winner = teamStates.winner;

            return GameSummaryScreen(winningTeamName: winner.name);
          },
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
}
