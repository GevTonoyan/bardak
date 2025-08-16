import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_route.dart';
import 'package:boardify/features/feature_alias_settings/data/data_sources/alias_settings_local_data_source.dart';
import 'package:boardify/features/feature_alias_settings/data/repositories/alias_settings_repository_impl.dart';
import 'package:boardify/features/feature_alias_settings/domain/entities/alias_settings_entity.dart';
import 'package:boardify/features/feature_alias_settings/domain/repositories/alias_settings_repository.dart';
import 'package:boardify/features/feature_alias_settings/domain/usecases/update_alias_setting_usecase.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_bloc.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_event.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_state.dart';
import 'package:boardify/features/feature_alias_settings/presentation/ui/alias_settings_screen.dart';
import 'package:boardify/features/feature_gameplay/domain/entities/alias_game_state_entity.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_local_data_source.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_remote_data_source.dart';
import 'package:boardify/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/feature_main/domain/repositories/alias_main_repository.dart';
import 'package:boardify/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:boardify/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:boardify/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:boardify/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/feature_word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/feature_word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/ui_kit/widgets/alias_setting_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AliasMainScreen extends StatefulWidget {
  const AliasMainScreen({super.key});

  @override
  State<AliasMainScreen> createState() => _AliasMainScreenState();
}

class _AliasMainScreenState extends State<AliasMainScreen> {
  int selectedModeIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = context.read<AliasMainBloc>();
    bloc.add(InitializeAliasMainEvent(locale: context.locale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final textStyles = theme.typography;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocBuilder<AliasMainBloc, AliasMainState>(
            builder: (context, state) {
              // Check if the word packs are cached
              final isDisabled = state is! AliasMainLoaded;

              return Column(
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
                    onPressed: isDisabled ? null : () => context.goNamed(AliasRouteNames.preGame),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.localizations.general_startGame),
                  ),
                  const SizedBox(height: 12),

                  // 🎬 Word Pack
                  OutlinedButton.icon(
                    onPressed:
                        isDisabled
                            ? null
                            : () async {
                              await context.pushNamed(AliasRouteNames.wordPacks);
                              if (context.mounted) {
                                context.read<AliasMainBloc>().add(
                                  GetSelectedWordPackNameEvent(locale: context.locale.languageCode),
                                );
                              }
                            },
                    icon: const Icon(Icons.category),
                    label: Text(_getWordPackName(state)),
                  ),

                  if (state is AliasMainError) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              Icon(Icons.wifi_off, color: colors.error, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${context.localizations.alias_failedLoadWords} ${context.localizations.general_checkInternet}',
                                  style: textStyles.bodyMedium.copyWith(
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
                              context.read<AliasMainBloc>().add(
                                InitializeAliasMainEvent(locale: context.locale.languageCode),
                              );
                            },
                            icon: Icon(Icons.refresh, color: colors.onPrimary),
                            label: Text(
                              context.localizations.general_tryAgain,
                              style: textStyles.labelLarge.copyWith(color: colors.onPrimary),
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

  String _getWordPackName(AliasMainState state) {
    final selectedWordPackName = (state is AliasMainLoaded ? state.selectedWordPackName : '') ?? '';

    final sb = StringBuffer();
    sb.write(context.localizations.alias_wordPack);
    if (selectedWordPackName.isNotEmpty) {
      sb.write(' • ');
      sb.write(selectedWordPackName);
    }

    return sb.toString();
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
