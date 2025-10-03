import 'package:boardify/core/dependency_injection/di.dart';
import 'package:boardify/features/card_round/domain/card_round_entity.dart';
import 'package:boardify/features/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:boardify/features/card_round/presentation/ui/card_round_screen.dart';
import 'package:boardify/features/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/features/game_session/presentation/ui/game_session_screen.dart';
import 'package:boardify/features/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/features/home/presentation/ui/home_screen.dart';
import 'package:boardify/features/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:boardify/features/pre_game/presentation/ui/pre_game_screen.dart';
import 'package:boardify/features/rules/presentation/ui/rules_screen.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/single_word_round/domain/single_word_round_entity.dart';
import 'package:boardify/features/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:boardify/features/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:boardify/features/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:boardify/features/word_pack/presentation/ui/word_packs_screen.dart';
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

                    final words = _getMockedWords().sublist(0, 10);

                    return BlocProvider(
                      create:
                          (_) => SingleWordRoundBloc(
                            words: words,
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
          ],
        ),
      ],
    ),
  ],
);

List<String> _getMockedWords() {
  //create 40 unique english words and return them as a set
  return [
    'Mountain',
    'Laptop',
    'Book',
    'Guitar',
    'River',
    'Spaceship',
    'Chocolate',
    'Umbrella',
    'Ocean',
    'Forest',
    'Desert',
    'Castle',
    'Dragon',
    'Knight',
    'Wizard',
    'Pirate',
    'Treasure',
    'Island',
    'Volcano',
    'Canyon',
    'Bridge',
    'Tower',
    'Garden',
    'Library',
    'Museum',
    'Theater',
    'Cinema',
    'Restaurant',
    'Cafe',
    'Market',
    'School',
    'Hospital',
    'Airport',
    'Station',
    'Hotel',
    'Beach',
    'Park',
    'Zoo',
    'Aquarium',
  ];
}

class RouteNames {
  static const initial = '/';
  static const info = 'info';
  static const wordPacks = 'word_packs';

  static const countdown = 'countdown';
  static const gameplay = 'gameplay';
  static const gameSummary = 'game_summary';
}
