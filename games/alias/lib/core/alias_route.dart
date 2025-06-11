import 'package:alias/core/alias_constants.dart';
import 'package:alias/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:alias/features/feature_main/presentation/ui/alias_main_screen.dart';
import 'package:alias/features/feature_gameplay/presentation/bloc/alias_play_bloc.dart';
import 'package:alias/features/feature_gameplay/presentation/ui/alias_card_mode_gameplay_screen.dart';
import 'package:alias/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:alias/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:alias/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:alias/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:alias/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:alias/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:alias/features/feature_settings/presentation/bloc/alias_settings_bloc.dart';
import 'package:alias/features/feature_settings/presentation/ui/alias_settings_screen.dart';
import 'package:alias/features/feature_word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:alias/features/feature_word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import '../features/feature_settings/alias_settings_scope.dart';

class AliasRouteNames {
  static const mainMenu = 'alias_main';
  static const aliasSettings = 'alias_settings';
  static const info = 'info';
  static const wordPacks = 'word_packs';
  static const preGame = 'pre_game';

  static const playSession = 'alias_play_session';
  static const roundOverview = 'alias_round_overview';
  static const countdown = 'alias_countdown';
  static const gameplay = 'alias_gameplay';
  static const gameSummary = 'alias_game_summary';
}

final aliasRouter = GoRoute(
  path: AliasRouteNames.mainMenu,
  name: AliasRouteNames.mainMenu,
  builder:
      (context, state) => BlocProvider(
        create:
            (_) => AliasMainBloc(
              fetchAndCacheWordPacks: sl(),
              areWordPacksCached: sl(),
              getSelectedWordPackName: sl(),
            ),
        child: AliasCardModeGameplayScreen(), //const AliasMainScreen(),
      ),
  routes: [
    GoRoute(
      path: AliasRouteNames.aliasSettings,
      name: AliasRouteNames.aliasSettings,
      builder:
          (context, state) => BlocProvider(
            create:
                (_) => AliasSettingsBloc(
                  getAliasSettingsUseCase: sl(),
                  updateAliasSettingUseCase: sl(),
                ),
            child: const AliasSettingsScreen(),
          ),
    ),
    GoRoute(
      path: AliasRouteNames.info,
      name: AliasRouteNames.info,
      builder: (context, state) => const AliasRulesScreen(),
    ),
    GoRoute(
      path: AliasRouteNames.wordPacks,
      name: AliasRouteNames.wordPacks,
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
      path: AliasRouteNames.preGame,
      name: AliasRouteNames.preGame,
      builder:
          (context, state) => BlocProvider(
            create: (_) => AliasPreGameBloc(getAliasSettingsUseCase: sl()),
            child: const AliasPreGameScreen(),
          ),
    ),

    GoRoute(
      path: AliasRouteNames.roundOverview,
      name: AliasRouteNames.roundOverview,
      builder: (context, state) {
        final preGameConfigString =
            state.uri.queryParameters[AliasConstants.preGameConfigKey]
                as String;
        final preGameConfig = AliasPreGameConfig.fromJson(preGameConfigString);

        return BlocProvider(
          create:
              (_) => AliasPlayBloc(
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
          path: AliasRouteNames.gameplay,
          name: AliasRouteNames.gameplay,
          builder: (context, state) {
            return const AliasGameplayScreen();
          },
        ),
        GoRoute(
          path: AliasRouteNames.countdown,
          name: AliasRouteNames.countdown,
          builder: (context, state) {
            return const AliasCountdownScreen();
          },
        ),
      ],
    ),
  ],
);
