import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/language_icon.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_overview_screen.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/features/games/alias/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:bardak/features/games/alias/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:bardak/features/games/alias/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:bardak/features/games/alias/word_pack/presentation/ui/language_select_screen.dart';
import 'package:bardak/features/games/alias/word_pack/presentation/ui/word_pack_item.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WordPackScreen extends StatefulWidget {
  const WordPackScreen({super.key});

  static const routePath = 'word_packs';

  @override
  State<WordPackScreen> createState() => _WordPackScreenState();
}

class _WordPackScreenState extends State<WordPackScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<WordPacksBloc>().add(
      LoadWordPacks(context.locale.languageCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocale.fromString(context.locale.languageCode);

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const .only(left: 20, top: 20, right: 20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                  LanguageIcon(
                    locale: appLocale,
                    size: 40,
                    onTap: () {
                      unawaited(
                        context.pushNamed(LanguageSelectScreen.routePath),
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocConsumer<WordPacksBloc, WordPacksState>(
              listenWhen: (_, current) => current is WordPacksNotCached,
              listener: (context, state) {
                if (state is WordPacksNotCached) {
                  unawaited(
                    showAppNotification(
                      context,
                      message: context.l10n.downloadWordsNetworkError,
                      icon: Icon(Icons.wifi_off, color: context.colors.white),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return switch (state) {
                  WordPacksInitial() => const SizedBox.shrink(),
                  WordPacksLoaded(: final packs) => Expanded(
                    child: _Success(packs: packs),
                  ),
                  WordPacksNotCached(fallbackPacks: final packs) => Expanded(
                    child: _Success(packs: packs, shouldDownload: true),
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.packs, this.shouldDownload = false});

  final List<WordPackEntity> packs;
  final bool shouldDownload;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        height30,
        Expanded(
          child: ListView.separated(
            padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
            itemBuilder: (context, index) {
              final pack = packs[index];

              return WordPackItem(
                name: pack.name,
                packWordsCount: pack.words.length,
                shouldDownload: shouldDownload,
                imageUrl: pack.image,
                imageBlurHash: pack.imageBlurHash,
                onTap: () {
                  if (shouldDownload) {
                    context.read<WordPacksBloc>().add(
                      FetchAndCachePacks(locale: context.locale.languageCode),
                    );
                  } else {
                    context.goNamed(
                      RoundOverviewScreen.routePath,
                      extra: _buildGameSessionEntity(context, pack),
                    );
                  }
                },
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemCount: packs.length,
          ),
        ),
      ],
    );
  }

  GameSessionEntity _buildGameSessionEntity(
    BuildContext context,
    WordPackEntity pack,
  ) {
    final appSettings = context.read<SettingsBloc>().state.appSettings;
    final gameSettings = context.read<GameSettingsBloc>().state.gameSettings;

    final preGame = context.read<PreGameBloc>().state;

    final words = pack.words..shuffle();

    return GameSessionEntity(
      gameMode: preGame.gameMode,
      teamStates: preGame.teamNames.map((teamName) {
        return AliasTeamStateEntity(
          name: teamName,
          roundScores: [],
        );
      }).toList(),
      roundDuration: gameSettings.roundDuration,
      pointsToWin: gameSettings.pointsToWin,
      soundEnabled: appSettings.soundEnabled,
      wordsPerCard: gameSettings.wordsPerCard,
      allowSkipping: gameSettings.allowSkipping,
      currentTeamIndex: 0,
      previousTeamIndex: 0,
      currentRoundIndex: 0,
      words: words,
    );
  }
}
