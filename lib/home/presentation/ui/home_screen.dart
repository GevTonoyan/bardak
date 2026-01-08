import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_text_button.dart';
import 'package:boardify/app_ui/widgets/coin_amount.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/game_session/presentation/ui/game_session_screen.dart';
import 'package:boardify/home/presentation/bloc/home_bloc.dart';
import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/pre_game/presentation/ui/pre_game_settings_screen.dart';
import 'package:boardify/rewards/presentation/ui/rewards_screen.dart';
import 'package:boardify/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/shop/presentation/ui/shop_screen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:boardify/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
    final colors = context.appTheme.colors;

    return Material(
      child: Stack(
        children: [
          Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: colors.main),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      // Check if the word packs are cached
                      final isDisabled = state is! HomeStateLoaded;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // IconButton(
                              //   icon: const Icon(Icons.settings),
                              //   color: colors.onBackground,
                              //   onPressed: () =>
                              //       context.goNamed(SettingsScreen.routePath),
                              // ),
                              AppIconButton.settings(
                                onTap: () => context.goNamed(
                                  SettingsScreen.routePath,
                                ),
                              ),
                              CoinAmount(
                                amount: 1000,
                                onTap: () {
                                  context.goNamed(ShopScreen.routePath);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 165,
                            width: 279,
                            child: Assets.logoAm.svg(),
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
                                border: Border.all(
                                  color: colors.error,
                                  width: 1.2,
                                ),
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
                                    icon: Icon(
                                      Icons.refresh,
                                      color: colors.onPrimary,
                                    ),
                                    label: Text(
                                      context.l10n.general_tryAgain,
                                      style: typography.labelLarge.copyWith(
                                        color: colors.onPrimary,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: colors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
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
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset('assets/shadow_effect.svg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  label: 'Classic Alias',
                  color: colors.green,
                  onPressed: () {
                    _navigateToGameSettings(GameMode.card);
                  },
                ),
                AppButton(
                  label: 'One Word Mode',
                  color: colors.purple,
                  onPressed: () {
                    _navigateToGameSettings(GameMode.singleWord);
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 44),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Rewards',
                      color: colors.white20,
                      onPressed: () => context.goNamed(RewardsScreen.routePath),
                    ),
                  ),

                  Expanded(
                    child: AppButton(
                      label: 'Shop',
                      color: colors.blue,
                      onPressed: () {
                        context.goNamed(ShopScreen.routePath);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGameSettings(GameMode gameMode) {
    context.goNamed(
      PreGameSettingsScreen.routePath,
      queryParameters: {PreGameSettingsScreen.gameModeKey: gameMode.name},
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
