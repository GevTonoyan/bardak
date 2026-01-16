import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/game_session/presentation/ui/round_overview_screen.dart';
import 'package:boardify/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:boardify/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:boardify/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:boardify/word_pack/presentation/ui/pack_card.dart';
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
    final preGameBloc = context.read<PreGameBloc>();

    return ScreenBackground(
      shadowHeight: 850,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
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
                  WordPacksLoaded(
                    packs: final packs,
                    selectedPackId: final selectedId,
                  ) =>
                    Expanded(
                      child: _Success(packs: packs, selectedId: selectedId),
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
          Icon(Icons.error_outline, color: colors.error, size: 48),
          const SizedBox(height: 16),
          Text(
            context.l10n.word_packs_fail,
            style: typography.titleMedium.copyWith(color: colors.error),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.packs, required this.selectedId});

  final List<AliasWordPackInfoEntity> packs;
  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final pack = packs[index];
              final gradientColors = _gradientColorsForPack(index);

              return PackCard(
                packName: pack.name,
                emoji: pack.emoji,
                startColor: gradientColors[0],
                endColor: gradientColors[1],
                isSelected: selectedId == pack.id,
                onTap: () {
                  context.read<WordPacksBloc>().add(
                    SelectWordPack(
                      packId: pack.id,
                      localeCode: Localizations.localeOf(context).languageCode,
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemCount: packs.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: AppButton(
            label: 'Go',
            color: context.colors.green,
            onPressed: () {
              final gameSession = _buildGameSessionEntity(
                context,
                packs,
                selectedId,
              );
              context.goNamed(
                RoundOverviewScreen.routePath,
                extra: gameSession,
              );
            },
          ),
        ),
      ],
    );
  }

  List<Color> _gradientColorsForPack(int index) {
    const gradients = [
      [Color(0xFF7F00FF), Color(0xFFE100FF)],
      [Color(0xFF56CCF2), Color(0xFF2F80ED)],
      [Color(0xFFFF512F), Color(0xFFDD2476)],
      [Color(0xFF43CEA2), Color(0xFF185A9D)],
      [Color(0xFFFFC371), Color(0xFFFF5F6D)],
      [Color(0xFF00C6FF), Color(0xFF0072FF)],
      [Color(0xFF00F260), Color(0xFF0575E6)],
      [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    ];
    return gradients[index % gradients.length];
  }

  GameSessionEntity _buildGameSessionEntity(
    BuildContext context,
    List<AliasWordPackInfoEntity> packs,
    String selectedPackId,
  ) {
    final gameSettings = context.read<SettingsBloc>().state.gameSettings;

    final preGame = context.read<PreGameBloc>().state;

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
      // TODO
      soundEnabled: false,
      wordsPerCard: gameSettings.wordsPerCard,
      allowSkipping: gameSettings.allowSkipping,
      penaltyForSkipping: gameSettings.penaltyForSkipping,
      currentTeamIndex: 0,
      currentRoundIndex: 0,
      words: packs.firstWhere((pack) => pack.id == selectedPackId).words,
    );
  }
}
