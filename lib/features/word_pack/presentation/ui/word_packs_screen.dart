import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/features/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/features/word_pack/presentation/bloc/word_packs_bloc.dart';
import 'package:boardify/features/word_pack/presentation/ui/pack_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordPackScreen extends StatefulWidget {
  const WordPackScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.wordPack)),
      body: SafeArea(
        child: BlocBuilder<WordPacksBloc, WordPacksState>(
          builder: (context, state) {
            return switch (state) {
              WordPacksInitial() => const SizedBox.shrink(),
              WordPacksError() => const _Error(),
              WordPacksLoaded(
                packs: final packs,
                selectedPackId: final selectedId,
              ) =>
                _Success(packs: packs, selectedId: selectedId),
            };
          },
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
  const _Success({required this.packs, this.selectedId});

  final List<AliasWordPackInfoEntity> packs;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
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
}
