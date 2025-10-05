import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/extensions/state_extension.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/game_session/presentation/ui/game_summary_screen.dart';
import 'package:boardify/features/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/features/pre_game/presentation/ui/pre_game_screen.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedModeIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<HomeBloc>().add(
      InitializeAliasHomeEvent(locale: context.locale.languageCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              // Check if the word packs are cached
              final isDisabled = state is! HomeStateLoaded;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔙 Back + ℹ️ Rules
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        color: colors.onBackground,
                        onPressed:
                            () => context.goNamed(SettingsScreen.routePath),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        color: colors.onBackground,
                        //onPressed: () => context.goNamed(RouteNames.info),
                        onPressed:
                            () => context.goNamed(GameSummaryScreen.routePath),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🖼 Hero Image
                  Expanded(
                    child: Image.asset(
                      AliasConstants.aliasCoverImagePath,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ▶️ Start Game
                  ElevatedButton.icon(
                    onPressed:
                        isDisabled
                            ? null
                            : () => context.goNamed(PreGameScreen.routePath),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.l10n.general_startGame),
                  ),
                  const SizedBox(height: 12),

                  // 🎬 Word Pack
                  OutlinedButton.icon(
                    onPressed:
                        isDisabled
                            ? null
                            : () async {
                              await context.pushNamed(RouteNames.wordPacks);
                              if (context.mounted) {
                                context.read<HomeBloc>().add(
                                  GetSelectedWordPackNameEvent(
                                    locale: context.locale.languageCode,
                                  ),
                                );
                              }
                            },
                    icon: const Icon(Icons.category),
                    label: Text(_getWordPackName(state)),
                  ),

                  if (state is HomeStateError) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.error, width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                color: colors.error,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${context.l10n.failedLoadWords}'
                                  ' ${context.l10n.general_checkInternet}',
                                  style: typography.bodyMedium.copyWith(
                                    color: colors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<HomeBloc>().add(
                                InitializeAliasHomeEvent(
                                  locale: context.locale.languageCode,
                                ),
                              );
                            },
                            icon: Icon(Icons.refresh, color: colors.onPrimary),
                            label: Text(
                              context.l10n.general_tryAgain,
                              style: typography.labelLarge.copyWith(
                                color: colors.onPrimary,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: colors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getWordPackName(HomeState state) {
    final selectedWordPackName =
        (state is HomeStateLoaded ? state.selectedWordPackName : '') ?? '';

    final sb = StringBuffer()..write(context.l10n.wordPack);
    if (selectedWordPackName.isNotEmpty) {
      sb
        ..write(' • ')
        ..write(selectedWordPackName);
    }

    return sb.toString();
  }
}

class GameModeSelector extends StatelessWidget {
  const GameModeSelector({
    required this.selectedIndex,
    required this.onChanged,
    required this.modes,
    super.key,
  });

  final int selectedIndex;
  final void Function(int) onChanged;
  final List<String> modes;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final textStyles = theme.typography;

    return Row(
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
                  color: colors.shadow.withValues(
                    alpha: isSelected ? 0.3 : 0.1,
                  ),
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
