import 'package:alias/alias_route.dart';
import 'package:alias/core/constants.dart';
import 'package:alias/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:app_core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AliasMainScreen extends StatefulWidget {
  const AliasMainScreen({super.key});

  @override
  State<AliasMainScreen> createState() => _AliasMainScreenState();
}

class _AliasMainScreenState extends State<AliasMainScreen> {
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AliasMainBloc>().add(CheckAndCacheAliasWords(locale: context.locale.languageCode));
  }

  int selectedModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final textStyles = theme.typography;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔙 Back + ℹ️ Rules
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: colors.onBackground,
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    color: theme.colors.onBackground,
                    onPressed: () => context.goNamed(AliasRouteNames.aliasSettings),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    color: colors.onBackground,
                    onPressed: () => context.goNamed(AliasRouteNames.info),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 🧩 Game Mode Selector
              Text(
                context.localizations.alias_selectMode,
                style: textStyles.titleMedium.copyWith(color: colors.onBackground),
              ),
              const SizedBox(height: 8),
              GameModeSelector(
                selectedIndex: selectedModeIndex,
                modes: [context.localizations.alias_mode1, context.localizations.alias_mode2],
                onChanged: (i) => setState(() => selectedModeIndex = i),
              ),

              const SizedBox(height: 20),

              // 🖼 Hero Image
              Expanded(
                child: Hero(
                  tag: AliasConstants.heroTag,
                  child: Image.asset(AliasConstants.aliasCoverImagePath, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 20),

              // ▶️ Start Game
              ElevatedButton.icon(
                onPressed: () => context.goNamed(AliasRouteNames.preGame),
                icon: const Icon(Icons.play_arrow),
                label: Text(context.localizations.general_startGame),
              ),

              const SizedBox(height: 12),

              // 🎬 Word Pack
              BlocBuilder<AliasMainBloc, AliasMainState>(
                builder: (BuildContext context, AliasMainState state) {
                  return OutlinedButton.icon(
                    onPressed: () {
                      context.goNamed(AliasRouteNames.wordPacks);
                    },
                    icon: const Icon(Icons.category),
                    label: Text('${context.localizations.alias_wordPack} • Movies'),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class GameModeSelector extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onChanged;
  final List<String> modes;

  const GameModeSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.modes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final textStyles = theme.typography;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(modes.length, (i) {
        final isSelected = selectedIndex == i;

        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: isSelected ? 0.3 : 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              modes[i],
              style: textStyles.bodyMedium.copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}
