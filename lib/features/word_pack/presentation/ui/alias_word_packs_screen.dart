
import 'package:boardify/features/word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';


class AliasWordPackScreen extends StatefulWidget {
  const AliasWordPackScreen({super.key});

  @override
  State<AliasWordPackScreen> createState() => _AliasWordPackScreenState();
}

class _AliasWordPackScreenState extends State<AliasWordPackScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AliasWordPacksBloc>().add(LoadWordPacks(context.locale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.typography;
    final colors = context.appTheme.colors;

    return Scaffold(
      appBar: AppBar(title: Text(context.localizations.alias_wordPack)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<AliasWordPacksBloc, AliasWordPacksState>(
            builder: (context, state) {
              switch (state) {
                case AliasWordPacksInitial():
                  return const SizedBox.shrink();
                case AliasWordPacksError():
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: colors.error, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          context.localizations.alias_word_packs_fail,
                          style: text.titleMedium.copyWith(color: colors.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                case AliasWordPacksLoaded():
                  {
                    final packs = state.packs;
                    final selectedId = state.selectedPackId;

                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                      shrinkWrap: true,
                      children: List.generate(packs.length, (index) {
                        final pack = packs[index];
                        final gradientColors = _gradientColorsForPack(index);

                        return _PackCard(
                          packName: pack.name,
                          emoji: pack.emoji,
                          startColor: gradientColors[0],
                          endColor: gradientColors[1],
                          isSelected: selectedId == pack.id,
                          onTap: () {
                            context.read<AliasWordPacksBloc>().add(
                              SelectWordPack(
                                packId: pack.id,
                                localeCode: Localizations.localeOf(context).languageCode,
                              ),
                            );
                          },
                        );
                      }),
                    );
                  }
              }
            },
          ),
        ),
      ),
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

class _PackCard extends StatelessWidget {
  final String packName;
  final String emoji;
  final Color startColor;
  final Color endColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackCard({
    required this.packName,
    required this.emoji,
    required this.startColor,
    required this.endColor,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: endColor.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            if (isSelected)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              packName,
              style: text.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
