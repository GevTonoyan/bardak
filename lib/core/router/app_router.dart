import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/app_review/presentation/cubit/in_app_review_cubit.dart';
import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:bardak/features/games/alias/card_round/presentation/ui/card_round_screen.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/round_review_bloc/round_review_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/countdown_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/game_session_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/game_summary_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_overview_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_review_screen.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/ui/game_settings_screen.dart';
import 'package:bardak/features/games/alias/rules/presentation/ui/rules_screen.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/ui/team_setup_screen.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/ui/language_select_screen.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/ui/word_packs_screen.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_language_select_screen.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_packs_screen.dart';
import 'package:bardak/features/games/spy/spy_rules/presentation/ui/spy_rules_screen.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_interrogation_screen.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_result_screen.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_role_reveal_screen.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_session_screen.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/ui/spy_settings_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/get_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_game_over_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_win_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/get_sudoku_settings_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/ui/sudoku_settings_screen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:bardak/features/settings/presentation/ui/settings_screen.dart';
import 'package:bardak/features/splash/presentation/splash_screen.dart';
import 'package:bardak/features/themes/presentation/ui/themes_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final gameSessionNavigatorKey = GlobalKey<NavigatorState>();
final spySessionNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: SplashScreen.routePath,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: SplashScreen.routePath,
      name: SplashScreen.routePath,
      pageBuilder: (context, state) =>
          const MaterialPage(child: SplashScreen()),
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
          path: SpyRulesScreen.routePath,
          name: SpyRulesScreen.routePath,
          pageBuilder: (context, state) => const SpyRulesScreen(),
        ),
        GoRoute(
          path: GameSettingsScreen.routePath,
          name: GameSettingsScreen.routePath,
          pageBuilder: (context, state) => const GameSettingsScreen(),
          routes: [
            GoRoute(
              path: TeamSetupScreen.routePath,
              name: TeamSetupScreen.routePath,
              pageBuilder: (context, state) => const TeamSetupScreen(),
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
                      const MaterialPage(child: WordPackScreen()),
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: SpySettingsScreen.routePath,
          name: SpySettingsScreen.routePath,
          pageBuilder: (context, state) => const SpySettingsScreen(),
          routes: [
            GoRoute(
              path: SpyPacksScreen.routePath,
              name: SpyPacksScreen.routePath,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SpyPacksScreen()),
              routes: [
                GoRoute(
                  path: SpyLanguageSelectScreen.routePath,
                  name: SpyLanguageSelectScreen.routePath,
                  pageBuilder: (context, state) =>
                      const SpyLanguageSelectScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: ThemesScreen.routePath,
          name: ThemesScreen.routePath,
          pageBuilder: (context, state) =>
              const MaterialPage(child: ThemesScreen()),
        ),
        GoRoute(
          path: SudokuSettingsScreen.routePath,
          name: SudokuSettingsScreen.routePath,
          pageBuilder: (context, state) => const SudokuSettingsScreen(),
          routes: [
            GoRoute(
              path: SudokuScreen.routePath,
              name: SudokuScreen.routePath,
              pageBuilder: (context, state) {
                final settings = sl<GetSudokuSettingsUseCase>()();
                // Resuming restores the saved snapshot; otherwise a fresh
                // puzzle is generated in the background by the bloc.
                final resume = state.extra == true;
                final savedGame = resume
                    ? sl<GetSavedSudokuGameUseCase>()()
                    : null;

                return MaterialPage(
                  child: BlocProvider(
                    create: (_) => SudokuBloc(
                      difficulty: settings.difficulty,
                      showTimer: settings.showTimer,
                      generateSudokuBoardUseCase: sl(),
                      updateSavedSudokuGameUseCase: sl(),
                      clearSavedSudokuGameUseCase: sl(),
                      recordSudokuWinUseCase: sl(),
                      savedGame: savedGame,
                    ),
                    child: const SudokuScreen(),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: SudokuWinScreen.routePath,
                  name: SudokuWinScreen.routePath,
                  pageBuilder: (context, state) => MaterialPage(
                    child: SudokuWinScreen(
                      args: state.extra! as SudokuWinArgs,
                    ),
                  ),
                ),
                GoRoute(
                  path: SudokuGameOverScreen.routePath,
                  name: SudokuGameOverScreen.routePath,
                  pageBuilder: (context, state) => MaterialPage(
                    child: SudokuGameOverScreen(
                      score: state.extra as int? ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
              path:
                  '${GameSessionScreen.routePath}/${RoundOverviewScreen.routePath}',
              name: RoundOverviewScreen.routePath,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: RoundOverviewScreen()),
            ),
            GoRoute(
              path:
                  '${GameSessionScreen.routePath}/${CountdownScreen.routePath}',
              name: CountdownScreen.routePath,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: CountdownScreen()),
            ),
            GoRoute(
              path:
                  '${GameSessionScreen.routePath}/${CardRoundScreen.routePath}',
              name: CardRoundScreen.routePath,
              pageBuilder: (context, state) {
                final session = context.read<GameSessionBloc>().state.session;

                return NoTransitionPage(
                  child: BlocProvider(
                    create: (_) => CardRoundBloc(
                      words: session.remainingWords,
                      wordsPerCard: session.wordsPerCard,
                      soundEnabled: session.soundEnabled,
                    ),
                    child: CardRoundScreen(
                      initialRoundDuration: session.roundDuration,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path:
                  '${GameSessionScreen.routePath}/${SingleWordRoundScreen.routePath}',
              name: SingleWordRoundScreen.routePath,
              pageBuilder: (context, state) {
                final session = context.read<GameSessionBloc>().state.session;

                return NoTransitionPage(
                  child: BlocProvider(
                    create: (_) => SingleWordRoundBloc(
                      words: session.remainingWords,
                      roundDuration: session.roundDuration,
                      allowSkipping: session.allowSkipping,
                      soundEnabled: session.soundEnabled,
                    ),
                    child: const SingleWordRoundScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              path:
                  '${GameSessionScreen.routePath}/${RoundReviewScreen.routePath}',
              name: RoundReviewScreen.routePath,
              pageBuilder: (context, state) {
                final session = context.read<GameSessionBloc>().state.session;
                final pending =
                    session.pendingReviewWords ?? const <ReviewedWord>[];
                return NoTransitionPage(
                  child: BlocProvider(
                    create: (_) => RoundReviewBloc(
                      words: List<ReviewedWord>.from(pending),
                      gameMode: session.gameMode,
                      wordsPerCard: session.wordsPerCard,
                    ),
                    child: const RoundReviewScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        ShellRoute(
          navigatorKey: spySessionNavigatorKey,
          builder: (context, state, child) {
            final spySession = state.extra as SpySessionEntity?;
            return SpySessionScreen(session: spySession, child: child);
          },
          routes: [
            GoRoute(
              path:
                  '${SpySessionScreen.routePath}/'
                  '${SpyRoleRevealScreen.routePath}',
              name: SpyRoleRevealScreen.routePath,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SpyRoleRevealScreen()),
            ),
            GoRoute(
              path:
                  '${SpySessionScreen.routePath}/'
                  '${SpyInterrogationScreen.routePath}',
              name: SpyInterrogationScreen.routePath,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SpyInterrogationScreen()),
            ),
          ],
        ),
        GoRoute(
          path: SpyResultScreen.routePath,
          name: SpyResultScreen.routePath,
          pageBuilder: (context, state) {
            final spySession = state.extra! as SpySessionEntity;
            return MaterialPage(child: SpyResultScreen(session: spySession));
          },
        ),
        GoRoute(
          path: GameSummaryScreen.routePath,
          name: GameSummaryScreen.routePath,
          pageBuilder: (context, state) {
            final winningTeamName = state.extra! as String;

            return MaterialPage(
              child: BlocProvider(
                create: (_) => sl<InAppReviewCubit>(),
                child: GameSummaryScreen(winningTeamName: winningTeamName),
              ),
            );
          },
        ),
      ],
    ),
  ],
);
