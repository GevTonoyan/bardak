import 'dart:async';

import 'package:bardak/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/app_ui/theme/colors/app_black_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_blue_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_brown_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_green_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_grey_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_main_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_mint_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_navy_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_orange_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_pink_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_plum_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_purple_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_red_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_turquoise_colors.dart';
import 'package:bardak/app_ui/theme/colors/app_yellow_colors.dart';
import 'package:bardak/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/app_ui/widgets/app_notification.dart';
import 'package:bardak/app_ui/widgets/coin_balance_widget.dart';
import 'package:bardak/app_ui/widgets/screen_background.dart';
import 'package:bardak/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/assets/assets.gen.dart';
import 'package:bardak/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:bardak/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/themes/presentation/bloc/themes_bloc.dart';
import 'package:bardak/themes/presentation/bloc/themes_event.dart';
import 'package:bardak/themes/presentation/bloc/themes_state.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  static const routePath = 'themes';

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  static const _itemHeight = 157.0;
  static const _separatorHeight = 12.0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTheme();
    });
  }

  void _scrollToSelectedTheme() {
    final selectedScheme = context
        .read<SettingsBloc>()
        .state
        .appSettings
        .colorScheme;
    final index = AppColorScheme.values.indexOf(selectedScheme);
    if (index <= 0 || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final itemTop = index * (_itemHeight + _separatorHeight);
    final itemBottom = itemTop + _itemHeight;

    final viewportTop = position.pixels;
    final viewportBottom = position.pixels + position.viewportDimension;

    // Already fully visible — do nothing.
    if (itemTop >= viewportTop && itemBottom <= viewportBottom) return;

    // Last item — scroll to the very bottom.
    if (index == AppColorScheme.values.length - 1) {
      _scrollController.animateTo(
        position.maxScrollExtent + 100,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
      return;
    }

    // Otherwise scroll so the item is near the top with some padding.
    final target = (itemTop - 20).clamp(0.0, position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typography = context.typography;
    final colors = context.colors;

    final bottomInset = MediaQuery.of(context).padding.bottom;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          spacing: 30,
          children: [
            Padding(
              padding: const .only(left: 20, top: 20, right: 20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                  const CoinBalanceWidget(),
                ],
              ),
            ),
            BlocBuilder<ThemesBloc, ThemesState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
                    itemBuilder: (context, index) {
                      final scheme = AppColorScheme.values[index];
                      return AppButton(
                        label: scheme.displayName(context),
                        color: _buttonBackgroundColor(scheme),
                        size: .extraLarge,
                        onPressed: () {
                          if (state.isOwned(scheme)) {
                            context.read<SettingsBloc>().add(
                              ChangeColorScheme(colorScheme: scheme),
                            );
                          } else {
                            unawaited(
                              showConfirmSheet(
                                context: context,
                                title: l10n.unlock_theme_title,
                                description: l10n.unlock_theme_description,
                                confirmText: l10n.unlock_theme_confirm,
                                cancelText: l10n.cancel,
                                confirmColor: colors.green,
                                cancelColor: colors.white20,
                                onConfirm: () async {
                                  final rewardsCubit = context
                                      .read<RewardsCubit>();
                                  final themesBloc = context.read<ThemesBloc>();

                                  final success = await rewardsCubit.spendCoins(
                                    AppConstants.themeCost,
                                  );

                                  if (success) {
                                    themesBloc.add(
                                      PurchaseTheme(theme: scheme),
                                    );
                                    context.read<SettingsBloc>().add(
                                      ChangeColorScheme(colorScheme: scheme),
                                    );
                                  } else {
                                    if (context.mounted) {
                                      unawaited(
                                        showAppNotification(
                                          context,
                                          message: l10n.not_enough_coins,
                                          icon: Assets.icons.coin.svg(
                                            width: 18,
                                            height: 18,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const .symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Assets.images.themeBackground.provider(),
                              opacity: 0.2,
                            ),
                          ),
                          child: Column(
                            children: [
                              _AppThemeOwnedInfo(scheme),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: .end,
                                  spacing: 8,
                                  children: [
                                    if (!state.isOwned(scheme))
                                      Assets.icons.lock.svg(),
                                    Text(
                                      scheme.displayName(context),
                                      style: typography.regular24,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: _separatorHeight),
                    itemCount: AppColorScheme.values.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _buttonBackgroundColor(AppColorScheme colorScheme) {
    return switch (colorScheme) {
      .main => AppMainColors().secondary,
      .purple => AppPurpleColors().secondary,
      .yellow => AppYellowColors().secondary,
      .blue => AppBlueColors().secondary,
      .green => AppGreenColors().secondary,
      .pink => AppPinkColors().secondary,
      .red => AppRedColors().secondary,
      .dark => AppBlackColors().secondary,
      .turquoise => AppTurquoiseColors().secondary,
      .orange => AppOrangeColors().secondary,
      .brown => AppBrownColors().secondary,
      .navy => AppNavyColors().secondary,
      .mint => AppMintColors().secondary,
      .plum => AppPlumColors().secondary,
      .grey => AppGreyColors().secondary,
    };
  }
}

class _AppThemeOwnedInfo extends StatelessWidget {
  const _AppThemeOwnedInfo(this.scheme);

  final AppColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemesBloc>().state;
    final settingsState = context.watch<SettingsBloc>();

    final isThemeOwned = themeState.isOwned(scheme);
    final isThemeSelected =
        settingsState.state.appSettings.colorScheme == scheme;

    final typography = context.typography;

    if (isThemeOwned) {
      return Align(
        alignment: .topRight,
        child: AppIconButton.themeOwned(
          context: context,
          isActive: isThemeSelected,
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: .end,
        spacing: 8,
        children: [
          Text(
            '${AppConstants.themeCost}',
            style: typography.regular24.withNumericFont,
          ),
          Assets.icons.coin.svg(
            width: 18,
            height: 18,
          ),
        ],
      );
    }
  }
}
