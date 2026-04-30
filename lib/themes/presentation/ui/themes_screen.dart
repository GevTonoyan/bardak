import 'dart:async';

import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:alias_pro/app_ui/theme/colors/app_black_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_blue_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_brown_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_dark_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_green_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_grey_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_main_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_mint_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_navy_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_orange_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_pink_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_plum_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_purple_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_red_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_turquoise_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_yellow_colors.dart';
import 'package:alias_pro/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/app_notification.dart';
import 'package:alias_pro/app_ui/widgets/coin_balance_widget.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/app_ui/widgets/show_confirm_sheet.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_event.dart';
import 'package:alias_pro/themes/presentation/bloc/themes_bloc.dart';
import 'package:alias_pro/themes/presentation/bloc/themes_event.dart';
import 'package:alias_pro/themes/presentation/bloc/themes_state.dart';
import 'package:alias_pro/utils/constants/constants.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  static const routePath = 'themes';

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
                    padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
                    itemBuilder: (context, index) {
                      final scheme = AppColorScheme.values[index];
                      return AppButton(
                        label: scheme.displayName(context),
                        color: _buttonBackgroundColor(scheme),
                        size: .extraLarge,
                        onPressed: () {
                          context.read<RewardsCubit>().updateCoins(0, 5000);
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
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
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
      .black => AppBlackColors().secondary,
      .turquoise => AppTurquoiseColors().secondary,
      .orange => AppOrangeColors().secondary,
      .brown => AppBrownColors().secondary,
      .navy => AppNavyColors().secondary,
      .mint => AppMintColors().secondary,
      .plum => AppPlumColors().secondary,
      .dark => AppDarkColors().secondary,
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
