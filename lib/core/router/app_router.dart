import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/router/invite_links.dart';
import 'package:bardak/core/router/navigation_guards.dart';
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
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/fire_at_opponent_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/report_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_game_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_result_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/ui/sea_battle_join_room_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/ui/sea_battle_waiting_room_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/sea_battle_online_scope.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/sea_battle_placement_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_rules/presentation/ui/sea_battle_rules_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/ui/sea_battle_settings_screen.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_language_select_screen.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_pack_editor_screen.dart';
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
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_game_over_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_win_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_rules/presentation/ui/sudoku_rules_screen.dart';
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

/// The app's router, created once in `main` by [createAppRouter].
late final GoRouter appRouter;

/// The app's router, opening on [initialLocation]: the splash screen, or
/// straight on the screen a link the app was opened with leads to.
GoRouter createAppRouter({required String initialLocation}) => GoRouter(
  initialLocation: initialLocation,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: kDebugMode,
  onEnter: guardNavigation,
  routes: [
    // Invite links (https://bardakgames.com/join/<code>) open here and
    // land on the join screen inside Sea Battle, so Back leads to its
    // settings and then home.
    GoRoute(path: inviteRoutePath, redirect: redirectInvite),
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
          pageBuilder: (context, state) =>
              const MaterialPage(child: RulesScreen()),
        ),
        GoRoute(
          path: SpyRulesScreen.routePath,
          name: SpyRulesScreen.routePath,
          pageBuilder: (context, state) =>
              const MaterialPage(child: SpyRulesScreen()),
        ),
        GoRoute(
          path: SudokuRulesScreen.routePath,
          name: SudokuRulesScreen.routePath,
          pageBuilder: (context, state) =>
              const MaterialPage(child: SudokuRulesScreen()),
        ),
        GoRoute(
          path: SeaBattleRulesScreen.routePath,
          name: SeaBattleRulesScreen.routePath,
          pageBuilder: (context, state) =>
              const MaterialPage(child: SeaBattleRulesScreen()),
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
                GoRoute(
                  path: SpyPackEditorScreen.routePath,
                  name: SpyPackEditorScreen.routePath,
                  pageBuilder: (context, state) => MaterialPage(
                    child: SpyPackEditorScreen(
                      initialPack: state.extra as SpyPackEntity?,
                    ),
                  ),
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
          path: SeaBattleSettingsScreen.routePath,
          name: SeaBattleSettingsScreen.routePath,
          pageBuilder: (context, state) => const SeaBattleSettingsScreen(),
          routes: [
            GoRoute(
              path: SeaBattleJoinRoomScreen.routePath,
              name: SeaBattleJoinRoomScreen.routeName,
              pageBuilder: (context, state) {
                final code = state
                    .pathParameters[SeaBattleJoinRoomScreen.codeParameter]!;
                return MaterialPage(
                  child: BlocProvider(
                    create: (_) => SeaBattleJoinRoomBloc(
                      joinSeaBattleRoomUseCase: sl(),
                    )..add(JoinRoom(code)),
                    child: SeaBattleJoinRoomScreen(code: code),
                  ),
                );
              },
            ),
            GoRoute(
              path: SeaBattleWaitingRoomScreen.routePath,
              name: SeaBattleWaitingRoomScreen.routePath,
              pageBuilder: (context, state) => MaterialPage(
                child: BlocProvider(
                  create: (_) => SeaBattleWaitingRoomBloc(
                    createSeaBattleRoomUseCase: sl(),
                    watchSeaBattleRoomUseCase: sl(),
                    leaveSeaBattleRoomUseCase: sl(),
                  )..add(const CreateRoom()),
                  child: const SeaBattleWaitingRoomScreen(),
                ),
              ),
            ),
            GoRoute(
              path: SeaBattlePlacementScreen.routePath,
              name: SeaBattlePlacementScreen.routePath,
              pageBuilder: (context, state) {
                final args = state.extra! as SeaBattlePlacementArgs;
                final room = args.room;
                return MaterialPage(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) =>
                            ShipPlacementBloc(generateRandomFleetUseCase: sl()),
                      ),
                      // Online: getting ready together, and leaving.
                      if (room != null)
                        BlocProvider(
                          create: (_) => SeaBattleOnlinePlacementBloc(
                            room: room,
                            watchSeaBattleRoomUseCase: sl(),
                            markSeaBattleRoomReadyUseCase: sl(),
                            startSeaBattleRoomBattleUseCase: sl(),
                            leaveSeaBattleRoomUseCase: sl(),
                          )..add(const WatchRoom()),
                        ),
                    ],
                    child: SeaBattlePlacementScreen(args: args),
                  ),
                );
              },
            ),
            GoRoute(
              path: SeaBattleGameScreen.routePath,
              name: SeaBattleGameScreen.routePath,
              pageBuilder: (context, state) {
                final args = state.extra! as SeaBattleGameArgs;
                final room = args.room;
                final opponentRepository = room == null
                    ? sl<SeaBattleOpponentRepository>(
                        param1: args.botDifficulty,
                      )
                    : sl<SeaBattleOpponentRepository>(
                        instanceName: onlineOpponentName,
                        param1: room.code,
                        param2: args.playerFleet,
                      );
                return MaterialPage(
                  child: BlocProvider(
                    create: (_) => SeaBattleGameBloc(
                      playerFleet: args.playerFleet,
                      startSeaBattleUseCase: sl(),
                      fireAtOpponentUseCase: FireAtOpponentUseCase(
                        opponentRepository,
                      ),
                      getOpponentShotUseCase: GetOpponentShotUseCase(
                        opponentRepository,
                      ),
                      reportOpponentShotUseCase: ReportOpponentShotUseCase(
                        opponentRepository,
                      ),
                      getOpponentFleetUseCase: GetOpponentFleetUseCase(
                        opponentRepository,
                      ),
                      getRandomShotUseCase: sl(),
                      // Online the host has picked who fires first, and
                      // every shot is timed.
                      firstTurn: room?.firstTurn,
                      turnTimeLimit: room == null
                          ? null
                          : SeaBattleRoomEntity.turnTimeLimit,
                    ),
                    child: SeaBattleGameScreen(args: args),
                  ),
                );
              },
            ),
            GoRoute(
              path: SeaBattleResultScreen.routePath,
              name: SeaBattleResultScreen.routePath,
              pageBuilder: (context, state) => MaterialPage(
                child: SeaBattleResultScreen(
                  args: state.extra! as SeaBattleResultArgs,
                ),
              ),
            ),
          ],
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
                      boardSize: settings.boardSize,
                      difficulty: settings.difficulty,
                      generateSudokuBoardUseCase: sl(),
                      updateSavedSudokuGameUseCase: sl(),
                      clearSavedSudokuGameUseCase: sl(),
                      recordSudokuWinUseCase: sl(),
                      getSudokuStatsUseCase: sl(),
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
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: SudokuGameOverScreen()),
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
              child: GameSummaryScreen(winningTeamName: winningTeamName),
            );
          },
        ),
      ],
    ),
  ],
);
