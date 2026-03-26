import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/game_session/domain/entities/game_session_entity.dart';
import 'package:alias_pro/game_session/presentation/ui/round_overview_screen.dart';
import 'package:alias_pro/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:alias_pro/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:alias_pro/word_pack/presentation/ui/word_pack_item.dart';
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
    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                ],
              ),
            ),
            BlocBuilder<WordPacksBloc, WordPacksState>(
              builder: (context, state) {
                return switch (state) {
                  WordPacksInitial() => const SizedBox.shrink(),
                  WordPacksError() => const _Error(),
                  WordPacksLoaded(packs: final packs) => Expanded(
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

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final typography = context.appTheme.typography;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Fail to load',
            style: typography.titleMedium.copyWith(color: colors.red),
            textAlign: TextAlign.center,
          ),
        ],
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
            itemBuilder: (BuildContext context, int index) {
              final pack = packs[index];

              return WordPackItem(
                name: pack.name,
                packWordsCount: pack.words.length,
                shouldDownload: shouldDownload,
                onTap: () {
                  context.goNamed(
                    RoundOverviewScreen.routePath,
                    extra: _buildGameSessionEntity(context, pack),
                  );
                },
                onDownload: () {
                  context.read<WordPacksBloc>().add(
                    FetchAndCachePacks(locale: context.locale.languageCode),
                  );
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
    final settings = context.read<SettingsBloc>().state;
    final gameSettings = settings.gameSettings;
    final appSettings = settings.appSettings;

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
      penaltyForSkipping: gameSettings.penaltyForSkipping,
      currentTeamIndex: 0,
      previousTeamIndex: 0,
      currentRoundIndex: 0,
      words: words,
    );
  }
}
