import 'package:boardify/utils/dependency_injection/di.dart';
import 'package:boardify/card_round/domain/card_round_entity.dart';
import 'package:boardify/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:boardify/card_round/presentation/ui/card_round_screen.dart';
import 'package:boardify/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/game_session/presentation/ui/game_session_screen.dart';
import 'package:boardify/game_session/presentation/ui/game_summary_screen.dart';
import 'package:boardify/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/home/presentation/ui/home_screen.dart';
import 'package:boardify/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:boardify/pre_game/presentation/ui/pre_game_screen.dart';
import 'package:boardify/rules/presentation/ui/rules_screen.dart';
import 'package:boardify/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/single_word_round/domain/single_word_round_entity.dart';
import 'package:boardify/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:boardify/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:boardify/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:boardify/word_pack/presentation/ui/word_packs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                  getWordsVersion: sl(),
                ),
            child: const HomeScreen(), //const AliasMainScreen(),
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
          builder: (context, state) => const RulesScreen(),
        ),
        GoRoute(
          path: RouteNames.wordPacks,
          name: RouteNames.wordPacks,
          builder:
              (context, state) => BlocProvider(
                create:
                    (_) => WordPacksBloc(
                      getWordPacks: sl(),
                      setSelectedWordPack: sl(),
                    ),
                child: const WordPackScreen(),
              ),
        ),
        GoRoute(
          path: PreGameScreen.routePath,
          name: PreGameScreen.routePath,
          builder:
              (context, state) => BlocProvider(
                create:
                    (_) => PreGameBloc(
                      getAliasSettingsUseCase: sl(),
                      getWordsByPack: sl(),
                    ),
                child: const PreGameScreen(),
              ),
        ),
        GoRoute(
          path: GameSessionScreen.routePath,
          name: GameSessionScreen.routePath,
          builder: (context, state) {
            final gameSessionEntity = state.extra as GameSessionEntity?;
            return GameSessionScreen(gameSessionEntity: gameSessionEntity);
          },
          routes: [
            GoRoute(
              path: CardRoundScreen.routePath,
              name: CardRoundScreen.routePath,
              builder: (context, state) {
                final roundEntity = state.extra! as CardRoundEntity;

                return BlocProvider(
                  create:
                      (_) => CardRoundBloc(
                        words: roundEntity.words,
                        wordsPerCard: roundEntity.wordsPerCard,
                      ),
                  child: CardRoundScreen(
                    initialRoundDuration: roundEntity.roundDuration,
                  ),
                );
              },
            ),
            GoRoute(
              path: SingleWordRoundScreen.routePath,
              name: SingleWordRoundScreen.routePath,
              builder: (context, state) {
                final roundEntity = state.extra! as SingleWordRoundEntity;

                return BlocProvider(
                  create:
                      (_) => SingleWordRoundBloc(
                        words: roundEntity.words,
                        roundDuration: roundEntity.roundDuration,
                        allowSkipping: roundEntity.allowSkipping,
                        penaltyForSkipping: roundEntity.penaltyForSkipping,
                      ),
                  child: const SingleWordRoundScreen(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: GameSummaryScreen.routePath,
          name: GameSummaryScreen.routePath,
          builder: (context, state) => const GameSummaryScreen(winningTeamName: 'Gevorg',),
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
