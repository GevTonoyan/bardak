import 'dart:io';

import 'package:alias_pro/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:alias_pro/card_round/presentation/ui/card_round_screen.dart';
import 'package:alias_pro/game_session/domain/entities/game_session_entity.dart';
import 'package:alias_pro/game_session/domain/entities/round_result.dart';
import 'package:alias_pro/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:alias_pro/game_session/presentation/bloc/round_review_bloc/round_review_bloc.dart';
import 'package:alias_pro/game_session/presentation/ui/countdown_screen.dart';
import 'package:alias_pro/game_session/presentation/ui/game_session_screen.dart';
import 'package:alias_pro/game_session/presentation/ui/game_summary_screen.dart';
import 'package:alias_pro/game_session/presentation/ui/round_overview_screen.dart';
import 'package:alias_pro/game_session/presentation/ui/round_review_screen.dart';
import 'package:alias_pro/home/presentation/ui/home_screen.dart';
import 'package:alias_pro/pre_game/domain/entities/pre_game_entity.dart';
import 'package:alias_pro/pre_game/presentation/ui/game_settings_screen.dart';
import 'package:alias_pro/pre_game/presentation/ui/setup_team_names_screen.dart';
import 'package:alias_pro/rewards/presentation/ui/rewards_screen.dart';
import 'package:alias_pro/rules/presentation/ui/rules_screen.dart';
import 'package:alias_pro/settings/presentation/ui/settings_screen.dart';
import 'package:alias_pro/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:alias_pro/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:alias_pro/splash/presentation/splash_screen.dart';
import 'package:alias_pro/themes/presentation/ui/themes_screen.dart';
import 'package:alias_pro/word_pack/presentation/ui/language_select_screen.dart';
import 'package:alias_pro/word_pack/presentation/ui/word_packs_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Page<T> _buildPlatformPage<T>({
  required Widget child,
  LocalKey? key,
}) {
  if (Platform.isAndroid) {
    CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
          ),
          child: child,
        );
      },
    );
  }
  return CupertinoPage<T>(key: key, child: child);
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final preGameNavigatorKey = GlobalKey<NavigatorState>();
final gameSessionNavigatorKey = GlobalKey<NavigatorState>();

const _gameSessionPath = 'gameSession';

final appRouter = GoRouter(
  initialLocation: SplashScreen.routePath,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: SplashScreen.routePath,
      name: SplashScreen.routePath,
      pageBuilder: (context, state) =>
          _buildPlatformPage(child: const SplashScreen()),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: HomeScreen.routePath,
      name: HomeScreen.routePath,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 1500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: SettingsScreen.routePath,
          name: SettingsScreen.routePath,
          pageBuilder: (context, state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: RulesScreen.routePath,
          name: RulesScreen.routePath,
          pageBuilder: (context, state) => const RulesScreen(),
        ),

        GoRoute(
          path: GameSettingsScreen.routePath,
          name: GameSettingsScreen.routePath,
          pageBuilder: (context, state) {
            final params = state.uri.queryParameters;
            final gameModeString = params[GameSettingsScreen.gameModeKey]!;
            final gameMode = GameMode.values.firstWhere(
              (mode) => mode.name == gameModeString,
            );
            return GameSettingsScreen(selectedMode: gameMode);
          },
          routes: [
            GoRoute(
              path: SetupTeamNamesScreen.routePath,
              name: SetupTeamNamesScreen.routePath,
              pageBuilder: (context, state) {
                return const SetupTeamNamesScreen();
              },
              routes: [
                GoRoute(
                  path: WordPackScreen.routePath,
                  name: WordPackScreen.routePath,
                  routes: [
                    GoRoute(
                      path: LanguageSelectScreen.routePath,
                      name: LanguageSelectScreen.routePath,
                      pageBuilder: (context, state) =>
                          const LanguageSelectScreen(),
                    ),
                  ],
                  pageBuilder: (context, state) =>
                      _buildPlatformPage(child: const WordPackScreen()),
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: RewardsScreen.routePath,
          name: RewardsScreen.routePath,
          pageBuilder: (context, state) =>
              _buildPlatformPage(child: const RewardsScreen()),
        ),
        GoRoute(
          path: ThemesScreen.routePath,
          name: ThemesScreen.routePath,
          pageBuilder: (context, state) =>
              _buildPlatformPage(child: const ThemesScreen()),
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
              pageBuilder: (context, state) =>
                  _buildPlatformPage(child: const RoundOverviewScreen()),
            ),
            GoRoute(
              path: '$_gameSessionPath/${CountdownScreen.routePath}',
              name: CountdownScreen.routePath,
              pageBuilder: (context, state) =>
                  _buildPlatformPage(child: const CountdownScreen()),
            ),
            GoRoute(
              path: '$_gameSessionPath/${CardRoundScreen.routePath}',
              name: CardRoundScreen.routePath,
              pageBuilder: (context, state) {
                final gameState = context
                    .read<GameSessionBloc>()
                    .state
                    .gameState;

                return NoTransitionPage(
                  child: BlocProvider(
                    create: (_) => CardRoundBloc(
                      words: gameState.words,
                      wordsPerCard: gameState.wordsPerCard,
                      soundsEnabled: gameState.soundEnabled,
                    ),
                    child: CardRoundScreen(
                      initialRoundDuration: gameState.roundDuration,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path: '$_gameSessionPath/${SingleWordRoundScreen.routePath}',
              name: SingleWordRoundScreen.routePath,
              pageBuilder: (context, state) {
                final gameState = context
                    .read<GameSessionBloc>()
                    .state
                    .gameState;

                return NoTransitionPage(
                  child: BlocProvider(
                    create: (_) => SingleWordRoundBloc(
                      words: gameState.words,
                      roundDuration: gameState.roundDuration,
                      allowSkipping: gameState.allowSkipping,
                      penaltyForSkipping: gameState.penaltyForSkipping,
                      soundsEnabled: gameState.soundEnabled,
                    ),
                    child: const SingleWordRoundScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              path: '$_gameSessionPath/${RoundReviewScreen.routePath}',
              name: RoundReviewScreen.routePath,
              pageBuilder: (context, state) {
                final gameState = context
                    .read<GameSessionBloc>()
                    .state
                    .gameState;
                final pending =
                    gameState.pendingReviewWords ?? const <ReviewedWord>[];
                return NoTransitionPage(
                  child: BlocProvider(
                    create: (_) => RoundReviewBloc(
                      words: List<ReviewedWord>.from(pending),
                      gameMode: gameState.gameMode,
                      wordsPerCard: gameState.wordsPerCard,
                    ),
                    child: const RoundReviewScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: GameSummaryScreen.routePath,
          name: GameSummaryScreen.routePath,
          pageBuilder: (context, state) {
            final teamStates = state.extra! as List<AliasTeamStateEntity>;
            final winner = teamStates.winner;

            return _buildPlatformPage(
              child: GameSummaryScreen(winningTeamName: winner.name),
            );
          },
        ),
      ],
    ),
  ],
);
